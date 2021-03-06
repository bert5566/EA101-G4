<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.util.*"%>
<%@ page import="com.bike.store.model.*"%>
<jsp:useBean id="BikeSvc" class="com.bike.bike.model.BikeService" scope="page" />
<link   rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/datetimepicker/jquery.datetimepicker.css" />


<%
BikeStoreService BikeStoreDAOService = new BikeStoreService();
List<BikeStoreVO> list = BikeStoreDAOService.getAll();
pageContext.setAttribute("list", list);
String action = request.getParameter("action");
if("payFinish".equals(action)){
	session.removeAttribute("startDate");
	session.removeAttribute("endDate");
	session.removeAttribute("matchBike");
	session.removeAttribute("bookMap");
}
%>

<html lang="en">
<head>


</head>
<body>
	<%@include file="/front-end/page-file/page-nav"%>
	
	<div class="container mt-3">
		<div class="row">
			<div class="col">
				<div class="row text-center">
					<div class="col">
						<label for="startDate">取車日期: </label> <input id="startDate" 
						name="startDate" type="text" autocomplete="off" placeholder="請選擇日期" >
					</div>
					<div class="col">
						<label for="endDate">還車日期 : </label> <input type="text" 
						id="endDate" name="endDate" autocomplete="off" placeholder="請選擇日期">
					</div>
				</div>
			</div>
		</div>
		<!-- 分頁 -->
		<div class="row mt-4">
			<div class="col-8">
				<nav class="nav nav-pills nav-fill nav-tabs nav-area">
					<a href="#" class=" nav-item nav-link  active" data-toggle="pill">全臺</a>
					<a href="#" class=" nav-item nav-link " data-toggle="pill">北部</a> <a
					href="#" class=" nav-item nav-link " data-toggle="pill">中部</a> <a
					href="#" class=" nav-item nav-link " data-toggle="pill">南部</a> <a
					href="#" class=" nav-item nav-link " data-toggle="pill">東部</a>
				</nav>
			</div>
			<div class="col-4">
				<div class="form-group row mt-1">
					<div>
						<input type="search" class="light-table-filter form-control" data-table="order-table" placeholder="搜尋店家" 
						id="Search">
					</div>
				</div>
			</div>
		</div>



		<div class="row">
			<div class="table-responsive">
				<table
				class="table table-striped table-hover text-center table-bordered order-table">
				<thead class="thead-light">
					<tr>
						<th scope="col">店家</th>
						<th scope="col">地址</th>
						<th scope="col">電話</th>
						<th scope="col">營業時間</th>
						<th scope="col">車輛數量</th>
					</tr>
				</thead>
				<tbody id="tbody">
					<c:forEach var="BikeStoreVO" items="${list}" varStatus="e">
					<tr>
					<input id="sq_bike_store_id" value="${BikeStoreVO.sq_bike_store_id}" type="hidden"/>
						<th>${BikeStoreVO.bike_store_name} </th>
						<th>${BikeStoreVO.location }</th>
						<th>${BikeStoreVO.phone }</th>
						<th>${BikeStoreVO.store_opentime }</th>
						<th>${BikeSvc.findStoreBikeEmpty(BikeStoreVO.sq_bike_store_id)}</th>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>


</div>

<%@include file="/front-end/page-file/page-footer"%>
<script src="<%=request.getContextPath()%>/datetimepicker/jquery.js"></script>
<script src="<%=request.getContextPath()%>/datetimepicker/jquery.datetimepicker.full.js"></script>
<script>
	
	$.datetimepicker.setLocale('zh');
	$(function(){
		$(".fun-text").text("預約租車");
		mouse_click_submit();
		mouse_hover();
		//ajax SearchArea
		$(".nav-area>a").click(function() {
			var area = $(this).text();
			$.ajax({
				type :"POST",
				url  : "<%=request.getContextPath()%>/bike/BikeStoreAjaxServlet.do",
				data : {
					action:"searchArea",
					area : area,                            
				},
				dataType: "JSON",
				success : function(data) {
					let str = "";
					$.each(data.returnValue, function(index, json) { 
						str+="<tr>";
						str+=
						"<td>"+json.bike_store_name+"</td>"+
						"<td>"+json.location+"</td>"+
						"<td>"+json.phone+"</td>"+
						"<td>"+json.store_opentime+"</td>"+
						"<td>"+json.empty_bike+"</td>";
						str+="</tr>";
					}); 
					$("tbody").empty();
					$("tbody").append(str);
				},complete:function(){
					//ajax submit data
					mouse_click_submit();
					mouse_hover();
				}
			})
		});
		


			//ajax SearchDate
			var startDate;
			var endDate;
			$('#startDate').change(function(){
				startDate =  $(this).val();
			})
			$('#endDate').change(function(){
				endDate =  $(this).val();
				$.ajax({
					type :"POST",
					url  :"<%=request.getContextPath()%>/bike/BikeStoreAjaxServlet.do",
					dataType : "JSON",
					data : {
						action : "searchDate",
						startDate : startDate,
						endDate : endDate,
					},
					success : function(data) {
						//獲取表格資料
						var tbody = document.getElementById("tbody");
						var rows = tbody.rows.length;

						for(var i =0 ; i <rows ; i++){					
								var storeName = tbody.rows[i].cells[0].innerText;
								tbody.rows[i].cells[4].innerHTML =data[storeName];
						}
					},complete:function(){
						//ajax submit data
						mouse_click_submit();
						mouse_hover();
					}
				})
			})

			

			
			
			
			

				
			

			//datetimepicker
			$('#startDate').datetimepicker(
			{
						timepicker : true, //timepicker: false,
						step : 60, //step: 60 (這是timepicker的預設間隔60分鐘)
						format : 'Y-m-d H:i',
						value : '',
						minDate : '-1970-01-01',
						timepicker : true,
						onShow : function() {
							this.setOptions({
								maxDate : $('#endDate').val() ? $('#endDate').val() : false
								
							})
						}
					//minDate:           '-1970-01-01', // 去除今日(不含)之前
					//maxDate:           '+1970-01-01'  // 去除今日(不含)之後
				});

			$('#endDate').datetimepicker(
			{
				format : 'Y-m-d H:i',
				onShow : function() {
					this.setOptions({
						minDate : $('#startDate').val() ? $('#startDate').val() : false
							
					})
				},

				timepicker : true,
				step : 60
			})
			
			//searchTables
			  'use strict';

			  // 建立 LightTableFilter
			  var LightTableFilter = (function(Arr) {

			    var _input;

			    // 資料輸入事件處理函數
			    function _onInputEvent(e) {
			      _input = e.target;
			      var tables = document.getElementsByClassName(_input.getAttribute('data-table'));
			      Arr.forEach.call(tables, function(table) {
			        Arr.forEach.call(table.tBodies, function(tbody) {
			          Arr.forEach.call(tbody.rows, _filter);
			        });
			      });
			    }

			    // 資料篩選函數，顯示包含關鍵字的列，其餘隱藏
			    function _filter(row) {
			      var text = row.textContent.toLowerCase(), val = _input.value.toLowerCase();
			      row.style.display = text.indexOf(val) === -1 ? 'none' : 'table-row';
			    }

			    return {
			      // 初始化函數
			      init: function() {
			        var inputs = document.getElementsByClassName('light-table-filter');
			        Arr.forEach.call(inputs, function(input) {
			          input.oninput = _onInputEvent;
			        });
			      }
			    };
			  })(Array.prototype);

			  // 網頁載入完成後，啟動 LightTableFilter
			  document.addEventListener('readystatechange', function() {
			    if (document.readyState === 'complete') {
			      LightTableFilter.init();
			    }
			  });
		});
	
	function mouse_click_submit(){
		//ajax submit data
		$("#tbody tr").click(function(e){
			var sq_bike_store_id = $(this).find("input").val();
			var startDate = $('#startDate').val();
			var endDate = $('#endDate').val();
			var matchBike = $(this).find("th").eq(4).text();
			
			//錯誤處理
			if(startDate=='' || endDate==''){
				alert("請先輸入日期");
				return;
			}
	
			$.ajax({
				type:"POST",
				url:"<%=request.getContextPath()%>/bike/BikeStoreAjaxServlet.do",
				data:{
					action:"confirm",
					sq_bike_store_id : sq_bike_store_id,
					startDate:startDate,
					endDate :endDate,
					matchBike : matchBike,
				},
				success:function(data){
					window.location.href = data;
				}
					
			});
		});
	}
	
	function mouse_hover(){

		//table hover
		$("#tbody tr").hover(function(){
			$(this).css('cursor', 'pointer');
			$(this).css('color', 'blue');
		},function(){
			$(this).css('color', 'inherit');
		})
	}
	
		//sweetAlertPayfinish
	<%
		if("payFinish".equals(action)){
	%>
			Swal.fire({
				  icon: 'success',
				  title: '恭喜!已成功預定',
				  showConfirmButton: false,
				  timer: 1500
				})
	<%
		}
	%>
	</script>

</body>
</html>
