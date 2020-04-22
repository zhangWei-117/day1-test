package com.xiaoshu.entity;


import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.persistence.Id;
import java.util.Date;
@Data
public class Hospital {
@Id
  private Integer id;
  private String name;
  private String address;
  private String img;
  private Integer num;
  @DateTimeFormat(pattern = "yyyy-MM-dd")
  private Date createtime;

  public Hospital() {
  }

  public Hospital(String name, String address, String img, Integer num, Date createtime) {
    this.name = name;
    this.address = address;
    this.img = img;
    this.num = num;
    this.createtime = createtime;
  }
}
