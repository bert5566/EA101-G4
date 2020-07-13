<%@ page contentType="text/html; charset=UTF-8" pageEncoding="Big5"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="com.brand.model.*"%>

<%
	BrandVO brandVO = (BrandVO) request.getAttribute("brandVO");
%>

<%@ include file="/back-end/backFrame/backHeader"%>
		<title>�t�P�޲z</title>
<%@ include file="/back-end/backFrame/backBody"%>
 		<div class="row" style="background-color: white;">
			<ul class="nav nav-tabs">
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/back-end/Shop_product/allShop_product.jsp"><span>�ӫ~�޲z</span></a>
				</li>
				<li class="nav-item">
					<a class="nav-link" href="<%=request.getContextPath()%>/back-end/Shop_order/allOrder.jsp"><span>�q��޲z</span></a>
				</li>
				<li class="nav-item">
					<a class="nav-link active" href="<%=request.getContextPath()%>/back-end/BrandBack/BrandBack.jsp"><span style="padding-bottom:8px; border-bottom: 3px blue solid;">�t�P�޲z</span></a>
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
			<FORM METHOD="post" ACTION="brand.do" style="position: relative;">
				<input type="text" name="sq_brand_id" id="search" placeholder="��J���u�s�� (�p520001):"/>
				<input type="hidden" name="action"	value="getOne">
				<input type="submit" value="�e�X" style="position: absolute; opacity: 0;" class="icon">
					<img src="image/search.png" class="img-fluid icon" >
			</FORM>
		</div>
	    <div class="col-1 ml-3" style="padding: 0;">
            	<button class="btn divbg" onclick="location.href='<%=request.getContextPath()%>/back-end/BrandBack/BrandBack.jsp'" style="border: 1px black solid;">
                    <img src="image/list.png" class="img-fluid">
                 </button>
        </div>
        <div class="col-1 ml-3" style="padding: 0;">
            <button class="btn divbg" onclick="location.href='<%=request.getContextPath()%>/back-end/BrandBack/addBrand.jsp'" style="border: 1px black solid;">
            	<img src="image/addbrand.png" class="img-fluid">
            </button>
        </div>
        <div class="col-3">
           	<jsp:useBean id="brandService" scope="page" class="com.brand.model.BrandService" />  
			<FORM METHOD="post" ACTION="brand.do" class="mt-2">
				<b>��ܼt�P�s��:</b>
				<select size="1" name="sq_brand_id">
					<c:forEach var="brandVO" items="${brandService.all}" > 
						<option value="${brandVO.sq_brand_id}">${brandVO.sq_brand_id}
					</c:forEach>   
				</select>
				<input type="hidden" name="action" value="getOne">
				<input type="submit" value="�e�X">
			</FORM>	
        </div>
    </div>
    <div class="row justify-content-center mt-3">
		<img src="image/noData.png" class="img-fluid mt-3">
    </div>
</div>
<%@ include file="/back-end/backFrame/backFooter" %>