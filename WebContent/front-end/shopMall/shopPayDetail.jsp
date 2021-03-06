<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.member.model.*"%>
<%@ page import="java.util.*"%>
<% 
	
%>

<!DOCTYPE html>
<html lang="en">
<head>
<!--    CSS幫你們引入完了  你們要額外新增在自己寫-->
	<link rel="stylesheet" href="<%=request.getContextPath()%>/front-end/shopMall/shopPayDetailCss.css">
</head>
<body>
	<%@include file="/front-end/page-file/page-nav"%>
 	
 	<div class="container my-5">
		<div class="container-fluid">
				<div class="row mb-2">
    				<div class="col-12">
    					<div class="pt-3 pl-3 pb-4" style="background-color: #cccccc; border-radius:10px;">
			    			<h3 class="pl-4">選擇領取地點</h3>
			    			<hr class="ml-4" style="width: 90%; margin-bottom: 10px; margin-top: 10px;">
							<div class="row">
								<div class="col-1"></div>
								<div class="col-4 choshop mt-3" id="choshop">
									<form>
										<input type="radio" name="service" id="home" value="home" class="mb-2" checked="true"> 
										<label for="home" style="font-size:150%;">宅配到府</label><br>
										<input type="radio" name="service" id="store" value="store" class="mb-2"> 
										<label for="store" style="font-size:150%;">超商取貨</label><br>
									</form>
									<table class="address-zone ml-3">
										<tr>
											<td><span>選擇縣市 : </span></td>
											<td class="shoptd">
												<select class="city" id="c1" disabled="disabled">
													<option value="">請選擇</option>
												</select>
											</td>
										</tr>
										<tr>
											<td><span>選擇行政區 : </span></td>
											<td class="shoptd">
												<select class="county" id="c2" disabled="disabled">
													<option value="">請選擇</option>
												</select>
											</td>
										</tr>
										<tr>
											<td><span>選擇門市 : </span></td>
											<td class="shoptd">
												<select name="shopname"  id="c3" disabled="disabled">
													<option>請選擇</option>
												</select>
												<form>
													<input type="hidden" class="zipcode" value="">
												</form>
											</td>
										</tr>
									</table>
									<div class="checkbtn mt-4">
<!-- 										<button id="sClear">清空</button> -->
<!-- 										<button id="sConfirm" disabled="disabled">確認</button> -->
									</div>
								</div>
								<div class="col-5 pt-2 pl-4" style="padding-right:0px;">
									<div id="map" style="height: 350px;width: 100%;"></div>
								</div>
								<div class="col-1"></div>
			    			</div>
		    			</div>
    				</div>
    			</div>
    			<div class="row mt-2">
    				<div class="col-12">
    					<div class="pt-3 pl-3 pb-3" style="background-color: #cccccc; border-radius:10px;">
			    			<h3 class="pl-4">收件人資訊</h3>
			    			<hr class="ml-4" style="width: 90%; margin-bottom: 10px; margin-top: 10px;">
			    			<div class="pl-4">
			    				<table>
			    					<tr>
			    						<td><input type="checkbox" class="samemem"></td>
			    						<td><span class="ml-1">同會員資訊</span></td>
			    						<td><button class="clean ml-4">清空</button></td>
			    					</tr>
			    				</table>			    				
			    			</div>
			    			<div class="pl-4">
			    				<FORM method="POST" action="<%=request.getContextPath()%>/shopping.do">
				    				<div class="takedt">
										<div>
				    						<label for="tname" class="takedt_t">收件人 :</label>
										    <input type="text" class="form-control ${errorMsgs.name==null?'':'is-invalid'}" id="tname" name="tname" value="${mapCus.name==null?'':mapCus.name}">
				    						<input type="hidden" id="name" value="${MemVO.m_name}">
				    						<input type="hidden" name="member_id" value="${MemVO.sq_member_id}">
				    						<div class="invalid-feedback">
											    ${errorMsgs.name}
											</div>
				    					</div>
				    					<div>
				    						<label for="tphone" class="takedt_t">連絡電話 :</label>
										    <input type="text" class="form-control ${errorMsgs.phone==null?'':'is-invalid'}" id="tphone" name="tphone" value="${mapCus.phone==null?'':mapCus.phone}">
				    						<input type="hidden" id="phone" value="${MemVO.cellphone}">
				    						<div class="invalid-feedback">
											    ${errorMsgs.phone}
											</div>
				    					</div>
										<div>
				    						<label for="temail" class="takedt_t">Email :</label>
										    <input type="text" class="form-control ${errorMsgs.email==null?'':'is-invalid'}" id="temail" name="temail" value="${mapCus.email==null?'':mapCus.email}">
				    						<input type="hidden" id="email" value="${MemVO.m_email}">
				    						<div class="invalid-feedback">
											    ${errorMsgs.email}
											</div>
				    					</div>
				    					<div>
				    						<label for="taddress" class="takedt_t">收件地址 :</label>
										    <input type="text" class="form-control ${errorMsgs.address==null?'':'is-invalid'}" id="taddress" name="taddress" value="${mapCus.address==null?'':mapCus.address}">
				    						<input type="hidden" id="address" value="${MemVO.address}">
				    						<div class="invalid-feedback">
											    ${errorMsgs.address}
											</div>
				    					</div>
				    				</div>			    				
					    			<div class="row mt-3">
					    				<div class="col-11">
					    					<div class="pt-2 pl-3 pb-2" style="background-color: #cccccc;">
					    						<div class="finalbtn">
					    							<button class="btn bg-secondary">上一步</button>
								    				<button class="btn bg-secondary">下一步</button>			
								    				<input type="hidden" name="paymode" id="paymode" value="">									
								    				<input type="hidden" name="action" value="toCheck">								    			
								    			</div>
							    			</div>
					    				</div>
					    				<div class="col-1"></div>
					    			</div>
			    				</FORM>			    				
		    				</div>
		    			</div>
    				</div>
    			</div>	
    		</div>
    		<div class="col-2"></div>
    	</div>

 		
	<%@include file="/front-end/page-file/page-footer"%>
	<script src="http://code.jquery.com/jquery-latest.min.js" type="text/javascript"></script>
	<script src="<%=request.getContextPath()%>/front-end/shopMall/js/aj-address.js" type="text/javascript"></script>
    <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyD8wygDormdKxQnhWGlBHvYJ7Q2HsT7F14&callback=initMap"></script>
	<script>
	
	function initMap(lat, lon) {
        var uluru = {lat: lat, lng: lon};
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 15,
          center: uluru
        });
        var marker = new google.maps.Marker({
          position: uluru,
          map: map
        });
      }
	
	$(document).ready(function(){	
		var a = $('input[name=service]:checked').val();
		$('#paymode').val(a);
		console.log($('#paymode').val());
		$('input[name=service]').change(function(){
			var b = $('input[name=service]:checked').val();
			console.log(b);
			$('#paymode').val(b);
		});
		
		$('.address-zone').ajaddress();
		
		$("#c3").change(function(){
			var name = $("#c3").val();
			console.log(name);
			$.ajax({
	        	type : "POST",		  
	        	url  : "<%=request.getContextPath()%>/store/storeServlet.do",
	        	dataType: 'json',
	        	data : {
	        		action : "getPosition",
	        		shopName : name,
	        	},
	        	success : function(data){
	        		initMap(data[0].lat, data[0].lon);
	        		$("#taddress").val(data[0].address);
	        		console.log($("input[name=taddress]").val());
	        	}
	    	});
		});
		
		$("#c2").change(function(){
			var key = $(".zipcode").val();
			console.log(key);
			if(key != ''){
				$.ajax({
		        	type : "POST",		  
		        	url  : "<%=request.getContextPath()%>/store/storeServlet.do",
		        	dataType: 'json',
		        	data : {
		        		action : "getShopName",
		        		directKey : key,
		        	},
		        	success : function(data){
		        		let str = "";
						if(data.length != 0){
						for(let index = 0 ; index < data.length ; index++) { 
							str += "<option id='shopName' value='"+data[index].name+"'>"+data[index].name+"</option>";
		        			}
		        		}
						$("#c3").empty();
  						$("#c3").append(str);
		        	}
		    	});
			}
		});
		$(".samemem").click(function(){
			if($(this).prop('checked')){
				$("#tname").val($("#name").val());
				$("#tphone").val($("#phone").val());
				$("#temail").val($("#email").val());
				if($("#taddress").val() == ""){
					$("#taddress").val($("#address").val());					
				}
			}
		});
		$(".clean").click(function(){
			$("#tname").val("");
			$("#tphone").val("");
			$("#temail").val("");
			$("#taddress").val("");
			$(".samemem").prop("checked", false);
		});
		
	});
	//鎖定選項
	var home = document.getElementById("home");
	var store = document.getElementById("store");
	var c1 = document.getElementById("c1");
	var c2 = document.getElementById("c2");
	var c3 = document.getElementById("c3");
	var sConfirm = document.getElementById("sConfirm");
	$('input[name=service]').change(function(){
		if(store.checked){
			c1.removeAttribute('disabled');
			c2.removeAttribute('disabled');
			c3.removeAttribute('disabled');

			$('#taddress').attr('readonly', true);
		}
		if(home.checked){
			c1.setAttribute('disabled', 'disabled');
			c2.setAttribute('disabled', 'disabled');
			c3.setAttribute('disabled', 'disabled');

			$('#taddress').attr('readonly', false);
		}
	});
	
	$(function(){
		$(".fun-text").text("付款方式");  // text("")裡面自己輸入功能名稱 
	});
	</script>

</body>
</html>
