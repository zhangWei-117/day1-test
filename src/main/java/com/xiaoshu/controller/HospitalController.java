package com.xiaoshu.controller;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.xiaoshu.config.util.ConfigUtil;
import com.xiaoshu.entity.Hospital;
import com.xiaoshu.entity.Operation;
import com.xiaoshu.entity.Role;
import com.xiaoshu.entity.User;
import com.xiaoshu.service.*;
import com.xiaoshu.util.StringUtil;
import com.xiaoshu.util.WriterUtil;
import lombok.extern.slf4j.Slf4j;
import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.jms.core.JmsTemplate;
import org.springframework.jms.core.MessageCreator;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartFile;

import javax.jms.Destination;
import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.Session;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Controller
@RequestMapping("hospital")
@Slf4j
public class HospitalController extends LogController {
    static Logger logger = Logger.getLogger(HospitalController.class);

    @Autowired
    private HospitalService userService;

    @Autowired
    private OperationService operationService;


    @RequestMapping("hospitalIndex")
    public String index(HttpServletRequest request, Integer menuid) throws Exception {
        List<Operation> operationList = operationService.findOperationIdsByMenuid(10);
        request.setAttribute("operationList", operationList);
        return "hospital";
    }


    @RequestMapping(value = "hospitalList", method = RequestMethod.POST)
    public void userList(HttpServletRequest request, HttpServletResponse response, String offset, String limit) throws Exception {
        try {
            String username = request.getParameter("key");
            String order = request.getParameter("order");
            String ordername = request.getParameter("ordername");

            Integer pageSize = StringUtil.isEmpty(limit) ? ConfigUtil.getPageSize() : Integer.parseInt(limit);
            Integer pageNum = (Integer.parseInt(offset) / pageSize) + 1;
            PageInfo<Hospital> userList = null;
            String s = JSON.toJSONString(username) + pageNum + ":" + pageSize;
            String o = (String) redisTemplate.boundHashOps("hospital").get(s);
            if (o != null) {
                log.error("缓存");
                userList = JSON.parseObject(o, PageInfo.class);
            } else {
                log.error("数据库");
                userList = userService.findUserPage(username, pageNum, pageSize, ordername, order);
                String string = JSON.toJSONString(userList);
                redisTemplate.boundHashOps("hospital").put(s,string);
            }


            JSONObject jsonObj = new JSONObject();
            jsonObj.put("total", userList.getTotal());
            jsonObj.put("rows", userList.getList());
            WriterUtil.write(response, jsonObj.toString());
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("用户展示错误", e);
            throw e;
        }
    }

    @Autowired
    private RedisTemplate redisTemplate;
    @Autowired
    JmsTemplate jmsTemplate;
    @Autowired
    Destination queueTextDestination;

    // 新增或修改
    @RequestMapping("reserve")
    public void reserveUser(HttpServletRequest reques, MultipartFile imgs, String a, String b, String c, final Hospital user, HttpServletResponse response) {
        Integer userId = user.getId();
        user.setAddress(a + "-" + b + "-" + c);
        JSONObject result = new JSONObject();
        try {
            if (imgs.getSize() > 1) {
                imgs.transferTo(new File("D:\\imges", imgs.getOriginalFilename()));
            }
            user.setImg("/"+imgs.getOriginalFilename());
            if (userId != null) {   // userId不为空 说明是修改
                user.setId(userId);
                userService.updateUser(user);
                redisTemplate.delete("hospital");
                result.put("success", true);
            } else {   // 添加
                userService.addUser(user);
                jmsTemplate.send(queueTextDestination, new MessageCreator() {
                    @Override
                    public Message createMessage(Session session) throws JMSException {
                        return session.createTextMessage(JSON.toJSONString(user));
                    }
                });
                redisTemplate.delete("hospital");
                result.put("success", true);
            }
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("保存用户信息错误", e);
            result.put("success", true);
            result.put("errorMsg", "对不起，操作失败");
        }
        WriterUtil.write(response, result.toString());
    }


    @RequestMapping("delete")
    public void delUser(HttpServletRequest request, HttpServletResponse response) {
        JSONObject result = new JSONObject();
        try {
            String[] ids = request.getParameter("ids").split(",");
            redisTemplate.delete("hospital");
            for (String id : ids) {
                userService.deleteUser(Integer.parseInt(id));
            }
            result.put("success", true);
            result.put("delNums", ids.length);
        } catch (Exception e) {
            e.printStackTrace();
            logger.error("删除用户信息错误", e);
            result.put("errorMsg", "对不起，删除失败");
        }
        WriterUtil.write(response, result.toString());
    }

    @RequestMapping("out")
    public void editPassword(HttpServletResponse response) {
        HSSFWorkbook workbook = new HSSFWorkbook();
        HSSFSheet sheet = workbook.createSheet();
        HSSFRow row1 = sheet.createRow(0);
        String[] arr = {"编号", "医院名称", "所在地", "已治愈人数", "治疗新冠人数", "创建时间"};
        for (int i = 0; i < arr.length; i++) {
            row1.createCell(i).setCellValue(arr[i]);
        }
        List<Hospital> user = userService.findUser(null);
        for (Hospital hospital : user) {
            int lastRowNum = sheet.getLastRowNum();
            HSSFRow row2 = sheet.createRow(lastRowNum + 1);
            row2.createCell(0).setCellValue(hospital.getId());
            row2.createCell(1).setCellValue(hospital.getName());
            row2.createCell(2).setCellValue(hospital.getAddress());
            row2.createCell(3).setCellValue(hospital.getImg());
            row2.createCell(4).setCellValue(hospital.getNum());
            row2.createCell(5).setCellValue(new SimpleDateFormat("yyyy-MM-dd").format(hospital.getCreatetime()));
        }
        response.setHeader("Content-Disposition", "attachment;filename=h.xls");
        response.setHeader("Content-Type", "application/octet-stream");
        try {
            workbook.write(response.getOutputStream());
            workbook.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequestMapping("in")
    public String in(MultipartFile file) {
        try {
            HSSFWorkbook workbook = new HSSFWorkbook(file.getInputStream());
            HSSFSheet sheetAt = workbook.getSheetAt(0);
            int lastRowNum = sheetAt.getLastRowNum();
            String[] arr = {"编号", "医院名称", "所在地", "已治愈人数", "治疗新冠人数", "创建时间"};
            for (int i = 1; i <= lastRowNum; i++) {
                HSSFRow row = sheetAt.getRow(i);
                String name = row.getCell(1).getStringCellValue();
                String address = row.getCell(2).getStringCellValue();
                String img = row.getCell(3).getStringCellValue();
                int num = (int) row.getCell(4).getNumericCellValue();
                Date createtime = new SimpleDateFormat("yyyy-MM-dd").parse(row.getCell(5).getStringCellValue());
                userService.addUser(new Hospital(name, address, img, num, createtime));
                redisTemplate.delete("hospital");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "redirect:hospitalIndex.htm";
    }

    @RequestMapping("getTu")
    public void getTu(HttpServletResponse response) {
        WriterUtil.write(response, JSON.toJSONString(userService.getTu()));
    }

    @Autowired
    private HdongService hdongService;

    @RequestMapping("geta")
    public void geta(HttpServletResponse response) {
        WriterUtil.write(response, JSON.toJSONString(hdongService.geta()));
    }

    @RequestMapping("getb")
    public void getb(HttpServletResponse response, int id) {
        WriterUtil.write(response, JSON.toJSONString(hdongService.getb(id)));
    }

    @RequestMapping("getc")
    public void getc(HttpServletResponse response, int id) {
        WriterUtil.write(response, JSON.toJSONString(hdongService.getc(id)));
    }
}
