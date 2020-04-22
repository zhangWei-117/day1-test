package com.xiaoshu.listener;

import com.alibaba.fastjson.JSON;
import com.xiaoshu.entity.Hospital;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

public class MyMessageListener implements MessageListener {
    @Autowired
    RedisTemplate redisTemplate;
    @Override
    public void onMessage(Message message) {
        TextMessage textMessage= (TextMessage) message;
        try {
            Hospital hospital = JSON.parseObject(textMessage.getText(), Hospital.class);
            String[] arr = hospital.getAddress().split("-");
            redisTemplate.boundHashOps("h").put(hospital+"",""+arr[0]+arr[1]+arr[2]);
        } catch (JMSException e) {
            e.printStackTrace();
        }
    }

}
