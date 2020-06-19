<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- <%@ page import="com.bike.type.model.*"%> --%>

<!DOCTYPE html>
<html>
<head>
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no" />

<!-- Bootstrap CSS -->

<link rel="stylesheet"
	href="<%=request.getContextPath()%>/bootstrap-components/css/bootstrap.min.css">
<!-- ss -->



<title>addBike</title>
	
</head>
<body>
	<a href="<%=request.getContextPath()%>/back-end/bikeType/bikeTypeListAll.jsp" class="btn btn-primary" >
  <span class="glyphicon glyphicon-arrow-left" >回上一頁</span>
	</a>

	<div class="container mt-5">
		<div class="row">
			<div class="col">
				<form method="POST" action="<%=request.getContextPath()%>/bike/BikeTypeServlet.do"
					enctype="multipart/form-data">
					<div class="form-group row">
						<label for="bikeType" class="col-sm-2 col-form-label">車種類型  </label>
						<input type="text" class="col-sm-10 form-control ${errorMsgs.bike_type_name==null?'':'is-invalid'} " id="bikeType"
							name="bike_type_name" placeholder="請輸入車種類型" value="${BikeTypeVO.bike_type_name}" >
						<!--errorMsg -->
						<div class="invalid-feedback col-sm-10 offset-md-2">${errorMsgs.bike_type_name}</div>
					</div>
					
					<div class="form-group row">
						<label for="bikeTitle" class="col-sm-2 col-form-label">單車標題</label>
						<input type="text" class="col-sm-10 form-control ${errorMsgs.bike_title==null?'':'is-invalid'}" id="bikeTitle"
							name="bike_title" placeholder="請輸入單車標題" value="${BikeTypeVO.bike_title}" >
						<!--errorMsg -->
						<div class="invalid-feedback col-sm-10 offset-md-2">${errorMsgs.bike_title}</div>
					</div>

					<div class="form-group row">
						<label for="bikePrice" class="col-sm-2 col-form-label ">價格</label>
						<input type="number" class="col-sm-10 form-control ${errorMsgs.price==null?'':'is-invalid'}" id="bikePrice"
							name="price" placeholder="價格" value="${BikeTypeVO.price}">
						<!--errorMsg -->
						<div class="invalid-feedback col-sm-10 offset-md-2">${errorMsgs.price}</div>
					</div>

					<div class="form-group row">
						<label for="bikeDesription" class="col-sm-2 col-form-label }">單車敘述</label>
						<textarea  id="bikeDesription" class="col-sm-10 form-control ${errorMsgs.bike_description==null?'':'is-invalid'}" 
							name="bike_description" rows="10">${BikeTypeVO.bike_description}</textarea>
						<!--errorMsg -->
						<div class="invalid-feedback col-sm-10 offset-md-2">${errorMsgs.bike_description}</div>
					</div>

					<div class="form-group row">
						<p class="col-sm-2 ">上傳圖片</p>
						<div class="custom-file col-sm-10 ">
							<input type="file" class="custom-file-input ${errorMsgs.bike_photo==null?'':'is-invalid'}" name="bike_photo"
								id="upLoad"> <label class="custom-file-label"
								for="upLoad" data-browse="上傳"></label>
						</div>
						<!--errorMsg -->
						<span class="invalid-feedback col-sm-10 offset-md-2">${errorMsgs.bike_photo}</span> 
					</div>

					<div id="showImg" class="text-center">
						<c:if test="${not empty errorMsgs}">
							<img src="<%=request.getContextPath()%>/photo/DBReader2.do" height="50%">
						</c:if>
					</div>

					<input type="hidden" name="action" value="insert">
					<button type="submit" class="btn btn-outline-primary btn-block m-5">新增</button>
				</form>
			</div>
		</div>
	</div>

	<!-- Optional JavaScript -->
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
	<script
		src="<%=request.getContextPath()%>/bootstrap-components/js/bootstrap.min.js"></script>

	<script>

		$("#upLoad").change(()=>{
			$("#showImg").empty();
			var files = $("#upLoad")[0].files;
			if(files != null & files.length > 0){
				var file = files[0];
				if(file.type.indexOf('image') != -1){
					$(".custom-file-label").text(file.name);
					var reader = new FileReader();
					reader.addEventListener('load',(e)=>{
						var result = e.target.result;
						var img = document.createElement("img");
						img.src = result;
						img.classList.add("img-fluid");
						$("#showImg").append(img);
					})
					reader.readAsDataURL(file);
				}
			}
		});
	</script>
</body>
</html>