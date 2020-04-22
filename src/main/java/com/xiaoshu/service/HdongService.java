package com.xiaoshu.service;

import com.xiaoshu.dao.HdongMapper;
import com.xiaoshu.entity.Hdong;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class HdongService {
    @Autowired
    HdongMapper mapper;

    public List<Hdong> geta() {
        return mapper.geta();
    }

    public List<Hdong> getb(int id) {
        return mapper.getb(id);
    }

    public List<Hdong> getc(int id) {
        return mapper.getc(id);
    }

}
