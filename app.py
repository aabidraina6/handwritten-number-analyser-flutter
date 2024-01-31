# import tensorflow as tf
# from PIL import Image
# import numpy as np
from flask import Flask

app = Flask(__name__)

@app.route('/hello/', methods=['GET', 'POST'])
def welcome():
    return "Hello World!"

# def predict():
#     mymodel = tf.keras.models.load_model('./saved_model/my_model')
#     # mymodel.summary()

#     image_path = './assets/img3.jpeg'
#     img = Image.open(image_path).convert('L')  # Convert to grayscale
#     img = img.resize(( 28, 28)) 

#     img_arr = np.array(img)

#     img_arr = img_arr.reshape((1 ,28 ,  28))
#     img_arr = img_arr/255.0

#     predictions = mymodel.predict(img_arr)
#     predicted_class = np.argmax(predictions)
#     print(predicted_class)
    
if __name__ == '__main__':
    app.run(host='0.0.0.0' , port=5000)
