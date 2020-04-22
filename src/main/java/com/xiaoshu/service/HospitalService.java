package com.xiaoshu.service;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.github.pagehelper.util.StringUtil;
import com.xiaoshu.dao.HospitalMapper;
import com.xiaoshu.dao.UserMapper;
import com.xiaoshu.entity.Custom;
import com.xiaoshu.entity.Hospital;
import com.xiaoshu.entity.User;
import com.xiaoshu.entity.UserExample;
import com.xiaoshu.entity.UserExample.Criteria;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import tk.mybatis.mapper.entity.Example;

import java.util.List;

@Service
public class HospitalService {

    @Autowired
    HospitalMapper userMapper;

    // 查询所有
    public List<Hospital> findUser(Hospital t) {
        return userMapper.select(t);
    }

    ;

    // 数量
    public int countUser(Hospital t) throws Exception {
        return userMapper.selectCount(t);
    }

    ;

    // 通过ID查询
    public Hospital findOneUser(Integer id) throws Exception {
        return userMapper.selectByPrimaryKey(id);
    }

    ;

    // 新增
    public void addUser(Hospital t) throws Exception {
        userMapper.insert(t);
    }

    ;

    // 修改
    public void updateUser(Hospital t) throws Exception {
        userMapper.updateByPrimaryKeySelective(t);
    }

    ;

    // 删除
    public void deleteUser(Integer id) throws Exception {
        userMapper.deleteByPrimaryKey(id);
    }


    public List<Custom> getTu() {
        return userMapper.getTu();
    }


    public PageInfo<Hospital> findUserPage(String user, int pageNum, int pageSize, String ordername, String order) {
        PageHelper.startPage(pageNum, pageSize);
        ordername = StringUtil.isNotEmpty(ordername) ? ordername : "userid";
        order = StringUtil.isNotEmpty(order) ? order : "desc";
        Example example = new Example(Hospital.class);
        example.setOrderByClause(ordername + " " + order);
        example.or().andLike("name", "%" + user + "%");
        example.or().andLike("address", "%" + user + "%");
        List<Hospital> userList = userMapper.selectByExample(example);
        PageInfo<Hospital> pageInfo = new PageInfo<Hospital>(userList);
        return pageInfo;
    }


}
