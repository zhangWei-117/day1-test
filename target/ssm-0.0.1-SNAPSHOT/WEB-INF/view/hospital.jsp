<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户主页</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@ include file="/WEB-INF/common.jsp" %>

    <link
            href="${path }/resources/css/plugins/bootstrap-table/bootstrap-table.min.css"
            rel="stylesheet">
    <link href="${path }/resources/css/animate.css" rel="stylesheet">
    <link href="${path }/resources/css/style.css?v=4.1.0" rel="stylesheet">

</head>
<body class="gray-bg">
<div class="panel-body">
    <div id="toolbar" class="btn-group">
        <c:forEach items="${operationList}" var="oper">
            <privilege:operation operationId="${oper.operationid }" id="${oper.operationcode }"
                                 name="${oper.operationname }" clazz="${oper.iconcls }"
                                 color="#093F4D"></privilege:operation>
        </c:forEach>
    </div>
    <div class="row">
        <div class="col-lg-2">
            <div class="input-group">
                <span class="input-group-addon">用戶名 </span>
                <input type="text" name="username" class="form-control" id="txt_search_username">
            </div>
        </div>
        <button id="btn_search" type="button" class="btn btn-default">
            <span class="glyphicon glyphicon-search" aria-hidden="true"></span>查询
        </button>
    </div>

    <table id="table_user"></table>

</div>

<!-- 新增和修改对话框 -->
<div class="modal fade" id="modal_user_edit" role="dialog" aria-labelledby="modal_user_edit" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <form id="form_user" method="post" enctype="multipart/form-data" action="reserve.htm">
                    <input type="hidden" name="id" id="hidden_txt_userid" value=""/>
                    <table style="border-collapse:separate; border-spacing:0px 10px;">
                        <tr>
                            <td>医院名称：</td>
                            <td><input type="text" id="name" name="name"
                                       class="form-control" aria-required="true" required/></td>
                            <td>&nbsp;&nbsp;</td>
                            <td>治疗新冠人数：</td>
                            <td><input type="text" id="num" name="num"
                                       class="form-control" aria-required="true" required/></td>
                        </tr>
                        <tr>
                            <td>所在地：</td>
                            <td colspan="4">
                                <select name="a" id="a" aria-required="true" onchange="fun1()" required>
                                    <option value="">---请选择---</option>
                                </select>
                                <select name="b" id="b" aria-required="true" onchange="fun2()" required>
                                    <option value="">---请选择---</option>
                                </select>
                                <select name="c" id="c" aria-required="true" required>
                                    <option value="">---请选择---</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>已经治愈人数：</td>
                            <td colspan="4"><input type="file" id="imgs" name="imgs"
                                       class="form-control" aria-required="true" required/></td>
                            </td>
                        </tr>
                    </table>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="submit_form_user_btn">保存</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </form>

            </div>

        </div>

    </div>

</div>


<!-- in -->
<div class="modal fade" id="modal_user_in" role="dialog" aria-labelledby="modal_user_edit" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <form id="form_user_in" enctype="multipart/form-data" method="post" action="in.htm">
                    <table style="border-collapse:separate; border-spacing:0px 10px;">
                        <tr>
                            <td>请选择：</td>
                            <td><input type="file" id="file" name="file"
                                       class="form-control" aria-required="true" required/></td>
                        </tr>
                    </table>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" id="submit_form_user_btn_in">保存</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    </div>
                </form>

            </div>

        </div>

    </div>

</div>


<!--删除对话框 -->
<div class="modal fade" id="modal_user_del" role="dialog" aria-labelledby="modal_user_del" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title" id="modal_user_del_head"> 刪除 </h4>
            </div>
            <div class="modal-body">
                删除所选记录？
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" id="del_user_btn">刪除</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
            </div>
        </div>
    </div>
</div>

<!--sel -->
<div class="modal fade" id="modal_user_sel" role="dialog" aria-labelledby="modal_user_del" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            </div>
            <div class="modal-body">
                <div id="main" style="height: 600px;width: 400px"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>


<div class="ui-jqdialog modal-content" id="alertmod_table_user_mod"
     dir="ltr" role="dialog"
     aria-labelledby="alerthd_table_user" aria-hidden="true"
     style="width: 200px; height: auto; z-index: 2222; overflow: hidden;top: 274px; left: 534px; display: none;position: absolute;">
    <div class="ui-jqdialog-titlebar modal-header" id="alerthd_table_user"
         style="cursor: move;">
        <span class="ui-jqdialog-title" style="float: left;">注意</span> <a id="alertmod_table_user_mod_a"
                                                                          class="ui-jqdialog-titlebar-close"
                                                                          style="right: 0.3em;"> <span
            class="glyphicon glyphicon-remove-circle"></span></a>
    </div>
    <div class="ui-jqdialog-content modal-body" id="alertcnt_table_user">
        <div id="select_message"></div>
        <span tabindex="0"> <span tabindex="-1" id="jqg_alrt"></span></span>
    </div>
    <div
            class="jqResize ui-resizable-handle ui-resizable-se glyphicon glyphicon-import"></div>
</div>

<!-- Peity-->
<script src="${path }/resources/js/plugins/peity/jquery.peity.min.js"></script>

<!-- Bootstrap table-->
<script src="${path }/resources/js/plugins/bootstrap-table/bootstrap-table.min.js"></script>
<script src="${path }/resources/js/plugins/bootstrap-table/locale/bootstrap-table-zh-CN.min.js"></script>

<!-- 自定义js-->
<script src="${path }/resources/js/content.js?v=1.0.0"></script>

<!-- jQuery Validation plugin javascript-->
<script src="${path }/resources/js/plugins/validate/jquery.validate.min.js"></script>
<script src="${path }/resources/js/plugins/validate/messages_zh.min.js"></script>

<!-- jQuery form  -->
<script src="${path }/resources/js/jquery.form.min.js"></script>

<script type="text/javascript">
    $(function () {
        init();
        $("#btn_search").bind("click", function () {
            //先销毁表格
            $('#table_user').bootstrapTable('destroy');
            init();
        });
        var validator = $("#form_user").validate({
            submitHandler: function (form) {
                $(form).ajaxSubmit({
                    dataType: "json",
                    success: function (data) {

                        if (data.success && !data.errorMsg) {
                            validator.resetForm();
                            $('#modal_user_edit').modal('hide');
                            $("#btn_search").click();
                        } else {
                            $("#select_message").text(data.errorMsg);
                            $("#alertmod_table_user_mod").show();
                        }
                    }
                });
            }
        });
        $("#submit_form_user_btn").click(function () {
            $("#form_user").submit();
        });
    });

    var init = function () {
        //1.初始化Table
        var oTable = new TableInit();
        oTable.Init();
        //2.初始化Button的点击事件
        var oButtonInit = new ButtonInit();
        oButtonInit.Init();
    };

    var TableInit = function () {
        var oTableInit = new Object();
        //初始化Table
        oTableInit.Init = function () {
            $('#table_user').bootstrapTable({
                url: 'hospitalList.htm',         //请求后台的URL（*）
                method: 'post',                      //请求方式（*）
                contentType: "application/x-www-form-urlencoded",
                toolbar: '#toolbar',                //工具按钮用哪个容器
                striped: true,                      //是否显示行间隔色
                cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
                pagination: true,                   //是否显示分页（*）
                sortable: true,                     //是否启用排序
                sortName: "id",
                sortOrder: "desc",                   //排序方式
                queryParams: oTableInit.queryParams,//传递参数（*）
                sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
                pageNumber: 1,                       //初始化加载第一页，默认第一页
                pageSize: 2,                       //每页的记录行数（*）
                pageList: [5, 7, 100],    //可供选择的每页的行数（*）
                search: false,                       //是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
                strictSearch: true,
                showColumns: true,                  //是否显示所有的列
                showRefresh: false,                  //是否显示刷新按钮
                minimumCountColumns: 2,             //最少允许的列数
                clickToSelect: true,                //是否启用点击选中行
                // height: 500,                        //行高，如果没有设置height属性，表格自动根据记录条数觉得表格高度
                uniqueId: "id",                     //每一行的唯一标识，一般为主键列
                showToggle: true,                    //是否显示详细视图和列表视图的切换按钮
                cardView: false,                    //是否显示详细视图
                detailView: false,                   //是否显示父子表
                columns: [{
                    checkbox: true
                },
                    {
                        field: 'id',
                        title: '编号',
                        sortable: true
                    },
                    {
                        field: 'name',
                        title: '医院名称',
                        sortable: true
                    },
                    {
                        field: 'address',
                        title: '所在地',
                        sortable: true
                    }, {
                        field: 'img',
                        title: '角色',
                        sortable: true,
                        formatter: function (value, row, index) {
                            return "<img src=" + value + " width=\"80\" height=\"80\"/>";
                        }
                    },
                    {
                        field: 'num',
                        title: '治疗新冠人数',
                        sortable: true
                    }, {
                        field: 'createtime',
                        title: '创建时间',
                        sortable: true,
                        formatter: function (value, row, index) {
                            var t = new Date(value);
                            return t.getFullYear() + "-" + (t.getMonth() + 1) + "-" + t.getDate();
                        }

                    }],
                onClickRow: function (row) {
                    $("#alertmod_table_user_mod").hide();
                }
            });
        };

        //得到查询的参数
        oTableInit.queryParams = function (params) {
            var temp = {//这里的键的名字和控制器的变量名必须一致，这边改动，控制器也需要改成一样的
                limit: params.limit,   //页面大小
                offset: params.offset,  //页码
                key: $("#txt_search_username").val(),
                search: params.search,
                order: params.order,
                ordername: params.sort
            };
            return temp;
        };
        return oTableInit;
    };

    var ButtonInit = function () {
        var oInit = new Object();
        var postdata = {};

        oInit.Init = function () {
            //初始化页面上面的按钮事件
            $("#btn_add").click(function () {
                $('#modal_user_edit').modal({backdrop: 'static', keyboard: false});
                $('#modal_user_edit').modal('show');
            });

            $("#btn_edit").click(function () {
                var getSelections = $('#table_user').bootstrapTable('getSelections');
                if (getSelections && getSelections.length == 1) {
                    initEditUser(getSelections[0]);
                    $('#modal_user_edit').modal({backdrop: 'static', keyboard: false});
                    $('#modal_user_edit').modal('show');
                } else {
                    $("#select_message").text("请选择其中一条数据");
                    $("#alertmod_table_user_mod").show();
                }

            });

            $("#btn_delete").click(function () {
                var getSelections = $('#table_user').bootstrapTable('getSelections');
                if (getSelections && getSelections.length > 0) {
                    $('#modal_user_del').modal({backdrop: 'static', keyboard: false});
                    $("#modal_user_del").show();
                } else {
                    $("#select_message").text("请选择数据");
                    $("#alertmod_table_user_mod").show();
                }
            });


        };

        return oInit;
    };

    $("#alertmod_table_user_mod_a").click(function () {
        $("#alertmod_table_user_mod").hide();
    });

    function initEditUser(getSelection) {
        $('#hidden_txt_userid').val(getSelection.id);
        $('#name').val(getSelection.name);
        $('#num').val(getSelection.num);
        // $('#a').val(getSelection.a);
    }

    $("#del_user_btn").click(function () {
        var getSelections = $('#table_user').bootstrapTable('getSelections');
        var idArr = new Array();
        var ids;
        getSelections.forEach(function (item) {
            idArr.push(item.id);
        });
        ids = idArr.join(",");
        $.ajax({
            url: "delete.htm",
            dataType: "json",
            data: {"ids": ids},
            type: "post",
            success: function (res) {
                if (res.success) {
                    $('#modal_user_del').modal('hide');
                    $("#btn_search").click();
                } else {
                    $("#select_message").text(res.errorMsg);
                    $("#alertmod_table_user_mod").show();
                }
            }
        });
    });
    $.post("geta.htm", function (data) {
        for (var i = 0; i < data.length; i++) {
            $("#a").append("<option id=" + data[i].id + ">" + data[i].title + "</option>")
        }
    },"json");
    function fun1() {
        var id = $("#a option:selected").attr("id");
        $.post("getb.htm", "id=" + id, function (data) {
            $("#b").empty();
            for (var i = 0; i < data.length; i++) {
                $("#b").append("<option id=" + data[i].id + ">" + data[i].title + "</option>")
            }
        },"json");
    };
    function fun2 () {
        var id = $("#b option:selected").attr("id");
        $.post("getc.htm", "id=" + id, function (data) {
            $("#c").empty();
            for (var i = 0; i < data.length; i++) {
                $("#c").append("<option id=" + data[i].id + ">" + data[i].title + "</option>")
            }
        },"json");
    };
    $("#btn_in").click(function () {
        $('#modal_user_in').modal({backdrop: 'static', keyboard: false});
        $('#modal_user_in').modal('show');
    });
    $("#submit_form_user_btn_in").click(function () {
        $("#form_user_in").submit();
    });

    $("#btn_out").click(function () {
    location.href="out.htm";
    });

    $("#btn_sel").click(function () {
        $('#modal_user_sel').modal({backdrop: 'static', keyboard: false});
        $('#modal_user_sel').modal('show');
        var list=new Array();
        var myChart=echarts.init(document.getElementById("main"));
        $.post(
            "getTu.htm",
            function (data) {
                for (var i = 0; i < data.length; i++) {
                    list[i]={
                        name:data[i].name,
                        value:data[i].num,
                    };
                }
                myChart.setOption({
                    title:{
                        text:"各省人数",
                        x:"center"
                    },
                    legend:{
                        orient:"vertical",
                        left:"left",
                        data:list.name
                    },
                    tooltip:{
                        formatter:"{a}<br/>{b}:{c}({d}%)"
                    },
                    series:[{
                        name:"人数",
                        type:"pie",
                        radius:"55%",
                        data:list
                    }]
                });
            },"json"
        )

    });
</script>

</body>
</html>