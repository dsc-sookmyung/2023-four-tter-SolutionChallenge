package com.gdsc.forder.service;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gdsc.forder.dto.PushNotificationDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import springfox.documentation.annotations.ApiIgnore;

@Service
@PropertySource("classpath:application.properties")
public class PushNotificationService {

    private Logger logger = LoggerFactory.getLogger(PushNotificationService.class);
    private FCMService fcmService;
    private ObjectMapper objectMapper;

    @Value("${fcm.server.key}")
    private String serverKey;

    public PushNotificationService(FCMService fcmService) {
        this.fcmService = fcmService;
    }

//    public void sendPushNotification(@ApiIgnore Principal principal, PushNotificationDTO request) {
//        try {
//            fcmService.sendMessage(getSamplePayloadData(), request);
//        } catch (Exception e) {
//            logger.error(e.getMessage());
//        }
//    }

    public void sendPillNotification(PushNotificationDTO request){
        try{

            fcmService.sendMessageToToken(request);
        }
        catch(Exception e){
            logger.error(e.getMessage());
        }
    }

    public void sendPushNotificationWithoutData(PushNotificationDTO request) {
        try {
            fcmService.sendMessageWithoutData(request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }


    public void sendPushNotificationToToken(PushNotificationDTO request) {
        try {
            fcmService.sendMessageToToken(request);
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }


    private Map<String, String> getSamplePayloadData() {
        Map<String, String> pushData = new HashMap<>();
        pushData.put("messageId", "msgid");
        pushData.put("text", "txt");
        pushData.put("user", "pankaj singh");
        return pushData;
    }

    public void subscribeTokenToTopic(String token, String topic){
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "key="+serverKey);

        HttpEntity entity = new HttpEntity(headers);
        RestTemplate restTemplate = new RestTemplate();
        String url = "https://iid.googleapis.com/iid/v1/" +token+"/rel/topics/"+topic;
        ResponseEntity<String> responseEntity =
                restTemplate.exchange(url, HttpMethod.POST, entity, String.class);
    }
}
