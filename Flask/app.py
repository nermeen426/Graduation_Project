from flask import Flask, request, render_template, send_file, jsonify
import os
import cv2
import numpy as np
import keras
from keras.models import load_model
from keras.utils import CustomObjectScope
from keras.initializers import glorot_uniform
import tensorflow as tf
from tensorflow.keras import backend as K
import matplotlib.pyplot as plt
from io import BytesIO
import base64
from PIL import Image
from keras.preprocessing import image
from werkzeug.utils import secure_filename
import nibabel as nib
import imageio
from heatmap import save_and_display_gradcam, make_gradcam_heatmap
app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 200 * 1024 * 1024  # or any other value suitable for your needs

# Define dice_coef function
def dice_coef_3d_seg(y_true, y_pred, smooth=1.0):
    class_num = 4
    for i in range(class_num):
        y_true_f = K.flatten(y_true[:, :, :, i])
        y_pred_f = K.flatten(y_pred[:, :, :, i])
        intersection = K.sum(y_true_f * y_pred_f)
        loss = ((2. * intersection + smooth) / (K.sum(y_true_f) + K.sum(y_pred_f) + smooth))
        if i == 0:
            total_loss = loss
        else:
            total_loss = total_loss + loss
    total_loss = total_loss / class_num
    return total_loss
def dice_coef(y_true, y_pred, smooth=1.0):
    class_num = 2  # Classes: tumor and background
    for i in range(class_num):
        y_true_f = K.flatten(y_true[:, :, :, i])
        y_pred_f = K.flatten(y_pred[:, :, :, i])
        intersection = K.sum(y_true_f * y_pred_f)
        loss = ((2. * intersection + smooth) / (K.sum(y_true_f) + K.sum(y_pred_f) + smooth))
        if i == 0:
            total_loss = loss
        else:
            total_loss = total_loss + loss
    total_loss = total_loss / class_num
    return total_loss

# Define precision function
def precision(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    predicted_positives = K.sum(K.round(K.clip(y_pred, 0, 1)))
    precision = true_positives / (predicted_positives + K.epsilon())
    return precision

# Define sensitivity function
def sensitivity(y_true, y_pred):
    true_positives = K.sum(K.round(K.clip(y_true * y_pred, 0, 1)))
    possible_positives = K.sum(K.round(K.clip(y_true, 0, 1)))
    return true_positives / (possible_positives + K.epsilon())

# Define specificity function
def specificity(y_true, y_pred):
    true_negatives = K.sum(K.round(K.clip((1 - y_true) * (1 - y_pred), 0, 1)))
    possible_negatives = K.sum(K.round(K.clip(1 - y_true, 0, 1)))
    return true_negatives / (possible_negatives + K.epsilon())

# Define dice_coef_necrotic function
def dice_coef_necrotic(y_true, y_pred, epsilon=1e-6):
    intersection = K.sum(K.abs(y_true[:, :, :, 1] * y_pred[:, :, :, 1]))
    return (2. * intersection) / (K.sum(K.square(y_true[:, :, :, 1])) + K.sum(K.square(y_pred[:, :, :, 1])) + epsilon)

# Define dice_coef_edema function
def dice_coef_edema(y_true, y_pred, epsilon=1e-6):
    intersection = K.sum(K.abs(y_true[:, :, :, 2] * y_pred[:, :, :, 2]))
    return (2. * intersection) / (K.sum(K.square(y_true[:, :, :, 2])) + K.sum(K.square(y_pred[:, :, :, 2])) + epsilon)

# Define dice_coef_enhancing function
def dice_coef_enhancing(y_true, y_pred, epsilon=1e-6):
    intersection = K.sum(K.abs(y_true[:, :, :, 3] * y_pred[:, :, :, 3]))
    return (2. * intersection) / (K.sum(K.square(y_true[:, :, :, 3])) + K.sum(K.square(y_pred[:, :, :, 3])) + epsilon)

# Load the Segmentation Model
model_path_segmentation = r"C:\Users\Mona\Downloads\final (2)\final\model.h5"
model_segmentation = load_model(
    model_path_segmentation,
    custom_objects={'dice_coef': dice_coef}
)

# Load the GradCAM Model
model_path_gradcam = r"C:\Users\Mona\Downloads\final (2)\final\CNN_BrainTumors.h5"
model_gradcam = tf.keras.models.load_model(model_path_gradcam)
model_gradcam.layers[-1].activation = None

# Load the 3D Segmentation Model
model_path_3d_segmentation = r"C:\Users\Mona\Downloads\final (2)\final\model_per_class.h5"
model_3d_segmentation = load_model(
    model_path_3d_segmentation,
    custom_objects={
        'accuracy': tf.keras.metrics.MeanIoU(num_classes=4),
        "dice_coef": dice_coef,
        "dice_coef_3d_seg": dice_coef_3d_seg,  # Add this new metric
        "precision": precision,
        "sensitivity": sensitivity,
        "specificity": specificity,
        "dice_coef_necrotic": dice_coef_necrotic,
        "dice_coef_edema": dice_coef_edema,
        "dice_coef_enhancing": dice_coef_enhancing
    },
    compile=False
)

# Common Functions

def preprocess_image(img_path):
    img = cv2.imread(img_path, cv2.IMREAD_GRAYSCALE)
    img = img.astype(np.uint8)
    img = cv2.resize(img, (256, 256))
    img = cv2.merge([img, img, img])
    img = np.expand_dims(img, 0)
    return img

# Common Configuration

# Class labels for predictions
class_dict = {0: "Pituitary", 1: "Meningioma", 2: "Glioma"}

# Route Functions

@app.route("/upload_segmentation", methods=["POST"])
def upload_segmentation():
    target = "upload"
    if not os.path.isdir(target):
        os.mkdir(target)

    upload = request.files.get("file")
    if upload is None:
        return jsonify({"error": "No file provided"})

    filename = secure_filename(upload.filename)
    destination = os.path.join(target, filename)
    upload.save(destination)

    image_path = destination
    img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
    img = img.astype(np.uint8)
    img = cv2.resize(img, (256, 256))
    img = cv2.merge([img, img, img])
    img = np.expand_dims(img, 0)

    # Debugging: Check input image
    print("Input Image Shape:", img.shape)
    print("Input Image Values:", img)

    predictions = model_segmentation.predict(img)

    # Debugging: Check unique values in the segmentation mask
    unique_values = np.unique(np.argmax(predictions, axis=3)[0, :, :])
    print("Unique Values in Segmentation Mask:", unique_values)

    # Save the segmentation mask as an image in the 'upload' folder
    segmentation_mask = np.argmax(predictions, axis=3)[0, :, :]
    output_path = os.path.join(target, 'segmentation.png')

    # Check if the segmentation result is all black (background)
    #if np.max(segmentation_mask) == 0:
        #return jsonify({"error": "Segmentation result is all black"})

    #fig, ax = plt.subplots(figsize=(8, 8))
    #ax.axis('off')
   # ax.imshow(segmentation_mask, cmap='gray')
    
    # Use a consistent filename for segmentation results (e.g., 'segmentation.png')
    segmentation_filename = 'segmentation.png'
    segmentation_output_path = os.path.join(target, segmentation_filename)
    
    plt.savefig(segmentation_output_path, bbox_inches='tight', pad_inches=0)
    plt.close()

    img_path = segmentation_output_path

    if os.path.exists(img_path):
        with open(img_path, 'rb') as img_output:
            img_bytes = img_output.read()
            img_base64 = base64.b64encode(img_bytes).decode('utf-8')
    else:
        # Handle the case where the file does not exist (e.g., print an error message)
        print("File not found:", img_output)

    return jsonify({"output_image": img_base64})
@app.route("/predict_gradcam", methods=['POST'])
def predict_gradcam():
    if request.method == 'POST':
        image = request.files['img']
        basepath = os.path.dirname(__file__)
        file_path = os.path.join(basepath, 'upload', secure_filename(image.filename))
        image.save(file_path)
        file_name = os.path.basename(file_path)
        pred, img = model_predict(file_path, model_gradcam)
        last_conv_layer_name = 'conv2d_2'
        heatmap = make_gradcam_heatmap(img, model_gradcam, last_conv_layer_name)
        fname = save_and_display_gradcam(file_path, heatmap)
        fname = os.path.join(basepath, 'upload', secure_filename(fname))

        if os.path.exists(fname):
            with open(fname, 'rb') as heatmap_file:
                heatmap_bytes = heatmap_file.read()
                heatmap_base64 = base64.b64encode(heatmap_bytes).decode('utf-8')
        else:
            print("File not found:", fname)

        ind = np.argmax(pred)
        prediction = class_dict[ind]
        response = {
            "prediction": prediction,
            "heatmap_image": heatmap_base64
        }
        return jsonify(response)

# Function to preprocess and predict using a model
def model_predict(img_path, model):
    img = Image.open(img_path).resize((224, 224))
    img = tf.keras.preprocessing.image.img_to_array(img)
    img = np.expand_dims(img, axis=0)
    img = img.astype('float32') / 255
    preds = model.predict(img)[0]
    prediction = sorted(
        [(class_dict[i], round(j * 100, 2)) for i, j in enumerate(preds)],
        reverse=True,
        key=lambda x: x[1]
    )
    return prediction, img

@app.route('/upload_3d_segmentation', methods=['POST'])
def upload_3d_segmentation():
    target = "upload"
    if not os.path.isdir(target):
        os.mkdir(target)

    flair_upload = request.files['flair_file']
    t1ce_upload = request.files['t1ce_file']

    if flair_upload.filename == '' or t1ce_upload.filename == '':
        return jsonify({'error': 'Both Flair and T1CE files are required'})

    flair_filename = secure_filename(flair_upload.filename)
    flair_path = os.path.join(target, flair_filename)
    flair_upload.save(flair_path)

    t1ce_filename = secure_filename(t1ce_upload.filename)
    t1ce_path = os.path.join(target, t1ce_filename)
    t1ce_upload.save(t1ce_path)

    create_prediction_gif_by_path(model_3d_segmentation, flair_path, t1ce_path, target)
    # Return the base64-encoded GIF file
    target=r"C:\Users\Mona\Downloads\final (2)\final\upload"
    gif_path = os.path.join(target, "predicted.gif")
    with open(gif_path, "rb") as gif_file:
        encoded_gif = base64.b64encode(gif_file.read()).decode('utf-8')
    return jsonify({'base64_encoded_gif': encoded_gif})

# Function to create a prediction GIF
def create_prediction_gif_by_path(model, flair_path, t1ce_path, output_folder=r"C:\Users\Mona\Downloads\final (2)\final\upload"):
    flair = nib.load(flair_path).get_fdata()
    ce = nib.load(t1ce_path).get_fdata()
    start_slice = 60 
    IMG_SIZE = 128
    SEGMENT_CLASSES = {
    0: 'NOT tumor',
    1: 'NECROTIC/CORE',  # or NON-ENHANCING tumor CORE
    2: 'EDEMA',
    3: 'ENHANCING'  # original 4 -> converted into 3 later
}

# there are 155 slices per volume
# to start at 5 and use 145 slices means we will skip the first 5 and last 5
    VOLUME_SLICES = 100
    VOLUME_START_AT = 22  # first slice of volume that we will include
    dim = (IMG_SIZE, IMG_SIZE)
    batch_size = 1
    n_channels = 2

    X = np.empty((VOLUME_SLICES, IMG_SIZE, IMG_SIZE, 2))

    for j in range(VOLUME_SLICES):
        idx = min(j + VOLUME_START_AT, flair.shape[2] - 1)
        X[j, :, :, 0] = cv2.resize(flair[:, :, idx], (IMG_SIZE, IMG_SIZE))
        X[j, :, :, 1] = cv2.resize(ce[:, :, idx], (IMG_SIZE, IMG_SIZE))

    predictions = model.predict(X / np.max(X), verbose=1)

    # Extract the predicted flair images
    predicted_flair_images = predictions[:, :, :, 0]

    # Save the predicted flair images as individual slices
    output_dir = os.path.join(output_folder, "predicted_slices")
    os.makedirs(output_dir, exist_ok=True)
    for i, predicted_flair_slice in enumerate(predicted_flair_images):
        cv2.imwrite(os.path.join(output_dir, f"predicted_flair_{i:03d}.png"), (predicted_flair_slice * 255).astype(np.uint8))

    # Create a GIF from the predicted flair images
    gif_output_path = os.path.join(output_folder, "predicted.gif")
    image_sequence = []
    for i in range(predicted_flair_images.shape[2]):
        image_sequence.append(predicted_flair_images[:, :, i])
    imageio.mimsave(gif_output_path, image_sequence, duration=0.1)

    print(f"GIF created and saved at: {gif_output_path}")

# Run the Flask app
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)
