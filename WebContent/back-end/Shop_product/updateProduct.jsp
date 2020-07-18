<%@ page contentType="text/html; charset=UTF-8" pageEncoding="Big5"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.shop_product.model.*"%>
<%@ page import="com.brand.model.*"%>

<%
	Shop_productVO productVO = (Shop_productVO) request.getAttribute("productVO");
%>

<%@ include file="/back-end/backFrame/backHeader"%>
		<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/back-end/Shop_product/addBrand.css">
		<title>�t�P�޲z</title>
<%@ include file="/back-end/backFrame/backBody"%>
 		<div class="row" style="background-color: white;">
			<ul class="nav nav-tabs">
				<li class="nav-item">
					<a class="nav-link active" href="<%=request.getContextPath()%>/back-end/Shop_product/allShop_product.jsp"><span style="padding-bottom:8px; border-bottom: 3px blue solid;">�ӫ~�޲z</span></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/back-end/Shop_order/allOrder.jsp"><span>�q��޲z</span></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/back-end/BrandBack/BrandBack.jsp"><span>�t�P�޲z</span></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/back-end/Product_stock/backProductStock.jsp"><span>�w�s�޲z</span></a>
				</li>
			</ul>
		</div>
<%@ include file="/back-end/backFrame/backNav" %>
<div class="container-fluid">
 	<div class="row mt-3">
            	<div class="col-3 searchbtn mt-1 ml-3">
					<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/shop_product.do" style="position: relative;">
						<input type="text" name="sq_product_id" id="search" placeholder="��J���~�s�� (�p510001):"/>
						<input type="hidden" name="action"	value="getOne">
						<input type="submit" value="�e�X" style="position: absolute; opacity: 0;" class="icon">
						<img src="<%=request.getContextPath()%>/back-end/backFrame/image/search.png" class="img-fluid icon" >
				    </FORM>
				</div>
				<div class="col-1 ml-3" style="padding: 0;">
              		<button class="btn divbg" onclick="location.href='<%=request.getContextPath()%>/back-end/Shop_product/allShop_product.jsp'" style="border: 1px black solid;">
                    	<img src="<%=request.getContextPath()%>/back-end/backFrame/image/list.png" class="img-fluid">
                    </button>
                </div>
                <div class="col-1 ml-3" style="padding: 0;">
                	<button class="btn divbg" onclick="location.href='<%=request.getContextPath()%>/back-end/Shop_product/addProduct.jsp'" style="border: 1px black solid;">
                    	<img src="<%=request.getContextPath()%>/back-end/backFrame/image/addbrand.png" class="img-fluid">
                    </button>
                </div>
                <div class="col-3">
                	<jsp:useBean id="shop_productService" scope="page" class="com.shop_product.model.Shop_productService" />  
					<FORM METHOD="post" ACTION="<%=request.getContextPath()%>/shop_product.do" class="mt-2">
						<b>��ܲ��~�s��:</b>
						<select size="1" name="sq_product_id">
							<c:forEach var="Shop_productVO" items="${shop_productService.all}" > 
								<option value="${Shop_productVO.sq_product_id}">${Shop_productVO.sq_product_id}
							</c:forEach>   
						</select>
						<input type="hidden" name="action" value="getOne">
						<input type="submit" value="�e�X">
					</FORM>	
                </div>
        	</div>
    <div class="row justify-content-center mt-3">
    	<h3>���~��Ƨ�s</h3>
    </div>
		<div class="row">
			<div class="col-2"></div>
			<div class="col-6">
				<c:if test="${not empty errorMsgs}">
					<font style="color:red">�Эץ��H�U���~:</font>
					<ul>
						<c:forEach var="message" items="${errorMsgs}">
							<li style="color:red; list-style-type: none;">${message}</li>
						</c:forEach>
					</ul>
				</c:if>
			</div>
		</div>
    	<div class="row mb-3">
    		<div class="col-2"></div>
    		<div class="col-8">
			<FORM method="post" action="<%=request.getContextPath()%>/shop_product.do" enctype="multipart/form-data" id="formid">
				<table>
					<tr>
						<td>���~�s�� : <%=productVO.getSq_product_id()%></td>
					</tr>
					<tr>
						<td>���~�W�� :</td>						
					</tr>
					<tr style="margin-dottom:10px;">
						<td><input type="TEXT" name="name" style="width:100%;"
							value="<%= (productVO==null)? "Giant" : productVO.getProduct_name()%>" /></td>
					</tr>

					<tr>
						<td>						
							��ܺ��� :
							<select size="1" name="kind_name">									
								<option value="�n�s��">�n�s���ۦ樮
								<option value="������">�������ۦ樮
								<option value="�V�M������">�V�M�������ۦ樮
								<option value="�M��A">�M��A
								<option value="�~�M/����">�~�M/����
								<option value="�B��/�B��">�B��/�B��
								<option value="�Ӷ�����">�Ӷ�����
								<option value="��M/�S�M">��M/�S�M"
								<option value="�f�n/���/�U�M">�f�n/���/�U�M
								<option value="�w���U">�w���U
								<option value="����">����
								<option value="����/�����[">����/�����[
								<option value="�~�L/���L">�~�L/���L
								<option value="����">����
								<option value="���׫O�i�u��">���׫O�i�u��
							</select>
							&nbsp; &nbsp; 
					<jsp:useBean id="brandSvc" scope="page" class="com.brand.model.BrandService" />											
							��ܼt�P :
							<select size="1" name="brand">
								<c:forEach var="brandVO" items="${brandSvc.all}">
									<option value="${brandVO.sq_brand_id}" ${(productVO.sq_brand_id == brandVO.sq_brand_id)? 'selected':'' } >${brandVO.brand_name}
								</c:forEach>
							</select>
							&nbsp; &nbsp; 					
							��J���� : 										
							<input type="TEXT" name="price"
							value="<%= (productVO==null)? "" : productVO.getProduct_price()%>" />
						</td>
					</tr>
					<tr>
						<td>�[�J�Ϥ� :</td>	
					</tr>
					<tr>
						<td><input type="FILE" name="pic" id="imgInp" accept="image/*"></td>
					</tr>
					<tr>
						<td>�Ϥ��w�� : </td>		
					</tr>
					<tr>
						<td>
							<img id="blah" src="<%=request.getContextPath()%>/showImg4?id=<%=productVO.getSq_product_id()%>" class="img-fluid" style="height:150px;">	 
						</td>
					</tr>
					<tr>
						<td>�ӫ~���� :</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" id="take" name="material">
							<textarea rows="3" id="give" style="width:100%"><%=(productVO==null)? "" : productVO.getProduct_material()%></textarea>
						</td>
					</tr>
					<tr>
						<td>�ӫ~���� :</td>
					</tr>
					<tr>
						<td>
							<input type="hidden" id="take2" name="detail">
							<textarea rows="5" id="give2" style="width:100%"><%= (productVO==null)? "" : productVO.getProduct_detail()%></textarea>
						</td>
					</tr>
					<tr>
						<td>�ӫ~���A :	
						<jsp:useBean id="productSvc" scope="page" class="com.shop_product.model.Shop_productService" />
							<select size="1" name="status">
								<option value="0">���W�[	
								<option value="1" selected>�w�W�[
								<option value="2">�ʳf��						
							</select>
						</td>
					</tr>
				</table>
				<div style="text-align: right;">
					<input type="submit" value="�e�X�ק�" onclick="upload()" style="text-align: right;">
					<input type="hidden" name="action" value="updateProduct">
					<input type="hidden" name="productID" value="<%=productVO.getSq_product_id()%>">
				</div>
			</FORM>
			</div>
			<div class="col-2"></div>
    	</div>
</div>
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
	<script>
		function upload(){
			document.getElementById('take').value = document.getElementById('give').value;
			document.getElementById('take2').value = document.getElementById('give2').value;
			document.getElementById('formid').submit();
		}
		function readURL(input) {
		  if (input.files && input.files[0]) {
		    var reader = new FileReader();
		    
		    reader.onload = function(e) {
		      $('#blah').attr('src', e.target.result);
		    }
		    
		    reader.readAsDataURL(input.files[0]); 
		  }
		}
		$("#imgInp").change(function() {
		  readURL(this);
		});
	</script>
<%@ include file="/back-end/backFrame/backFooter" %>