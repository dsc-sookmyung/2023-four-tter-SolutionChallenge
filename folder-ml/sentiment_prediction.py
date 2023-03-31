import numpy as np
import tensorflow as tf
import transformers
import KoBertTokenizer
from transformers import PreTrainedTokenizer
from tensorflow_addons.optimizers import RectifiedAdam

tokenizer = KoBertTokenizer.tokenizer

SEQ_LEN = 64
sentiment_model = tf.keras.models.load_model("sentiment_model_2.h5",
                                             custom_objects={"TFBertModel": transformers.TFBertModel})

class Prediction():
    def sentence_convert_data(self, data):
        tokens, masks, segments = [], [], []
        token = tokenizer.encode(data, max_length=SEQ_LEN, truncation=True, padding='max_length')

        num_zeros = token.count(0)
        mask = [1] * (SEQ_LEN - num_zeros) + [0] * num_zeros
        segment = [0] * SEQ_LEN

        tokens.append(token)
        segments.append(segment)
        masks.append(mask)

        tokens = np.array(tokens)
        masks = np.array(masks)
        segments = np.array(segments)
        return [tokens, masks, segments]


    def text_prediction(self, text):
        data_x = self.sentence_convert_data(text)
        predict = sentiment_model.predict(data_x)
        predict_value = np.ravel(predict)
        predict_answer = np.round(predict_value, 0).item()

        """
        if predict_answer == 0:
          print("(부정 확률 : %.2f) 부정입니다." % (1-predict_value))
        elif predict_answer == 1:
          print("(긍정 확률 : %.2f) 긍정입니다." % predict_value)

        """

        return predict_answer