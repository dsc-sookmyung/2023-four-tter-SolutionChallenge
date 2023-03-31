from flask import Flask, request
from flask_restx import Api, Resource, reqparse
import sentiment_prediction
import speech_recognition as sr
from gtts import gTTS

app = Flask(__name__)
api = Api(app, version='3.0', title='Folder API', description='Swagger 문서', doc="/api-docs")

test_api = api.namespace('STT', description='음성인식 API')
prediction_api = api.namespace('prediction', description='감정분석 긍부정 API')


@test_api.route('/STT')
class Test(Resource):
    def get(self):
        try:
            r = sr.Recognizer()

            with sr.Microphone() as source:
                audio = r.listen(source)
                try:
                    stt = r.recognize_google(audio, language='ko-KR')
                    return stt
                except sr.UnknownValueError:
                    print('오디오를 이해할 수 없습니다.')
                except sr.RequestError as e:
                    print(f'에러가 발생하였습니다. 에러원인 : {e}')

        except KeyboardInterrupt:
            pass


@prediction_api.route('/<string:text>')
class SentimentPredict(Resource):
    def get(self, text):
        predict = sentiment_prediction.Prediction()
        result = predict.text_prediction(text)
        return result


if __name__ == '__main__':
    app.run('0.0.0.0', port=8000)
