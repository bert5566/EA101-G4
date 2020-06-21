<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="BIG5"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ page import="java.util.*"%>
<%@ page import="com.shop_product.model.*"%>

<%
	Shop_productService shop_productSvc = new Shop_productService();
	List<Shop_productVO> list = shop_productSvc.getAll();
	pageContext.setAttribute("list", list);
%>
<%@ include file="/back-end/backFrame/backHeader"%>
 	<link rel="stylesheet" type="text/css" href="backBrand.css">
    <title>�t�P��x</title>
<%@ include file="/back-end/backFrame/backBody"%>
				<div class="row" style="background-color: white;">
					<ul class="nav nav-tabs">
					  <li class="nav-item">
					    <a class="nav-link active" href="#"><span style="padding-bottom:8px; border-bottom: 3px blue solid;">�ӫ~�޲z</span></a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="#"><span>�q��޲z</span></a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="#"><span>�t�P�޲z</span></a>
					  </li>
					</ul>
				</div>
<%@ include file="/back-end/backFrame/backNav" %>
		<div class="container-fluid">
			<div class="row mt-3">
            	<div class="col-3 searchbtn mt-1 ml-3">
					<FORM METHOD="post" ACTION="shop_product.do" style="position: relative;">
						<input type="text" name="sq_product_id" id="search" placeholder="��J���~�s�� (�p510001):"/>
						<input type="hidden" name="action"	value="getOne">
						<input type="submit" value="�e�X" style="position: absolute; opacity: 0;" class="icon">
						<img src="image/search.png" class="img-fluid icon" >
				    </FORM>
				</div>
				<div class="col-1 ml-3" style="padding: 0;">
              		<button class="btn divbg" onclick="location.href='<%=request.getContextPath()%>/back_end/Shop_product/BrandBack.jsp'" style="border: 1px black solid;">
                    	<img src="image/list.png" class="img-fluid">
                    </button>
                </div>
                <div class="col-1 ml-3" style="padding: 0;">
                	<button class="btn divbg" onclick="location.href='<%=request.getContextPath()%>/back_end/Shop_product/addBrand.jsp'" style="border: 1px black solid;">
                    	<img src="image/addbrand.png" class="img-fluid">
                    </button>
                </div>
                <div class="col-3">
                	<jsp:useBean id="shop_productService" scope="page" class="com.shop_product.model.Shop_productService" />  
					<FORM METHOD="post" ACTION="shop_product.do" class="mt-2">
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
        	<div class="row mt-3 justify-content-center">
    			<div class="col-12 divbg">
    				<div id="brandcontent">
    					<table style="table-layout:fixed;">
    						<thead>
    							<tr>
    								<th id="td_id"><span>���~�s��</span></th>
    								<th id="td_id"><span>�t�P�s��</span></th>
    								<th id="td_kind"><span>����</span></th>
    								<th id="td_stock"><span>�w�s</span></th>
    								<th id="td_name"><span>�W��</span></th>
    								<th id="td_price"><span>����</span></th>
    								<th id="td_pic"><span>�Ϥ�</span></th>
    								<th id="td_detail"><span>����</span></th>
    								<th id="td_model"><span>����</span></th>
    								<th id="td_color"><span>�C��</span></th>
    								<th id="td_date"><span>���</span></th>
    								<th id="td_mertail"><span>����</span></th>
    								<th id="td_status"><span>���A</span></th>
    								<th id="td_btn"></th>
    								<th id="td_btn"></th>
    							</tr>
    						</thead>
				   			<c:forEach var="brandVO" items="${list}">
				   				<tr>
				    				<td>${productVO.sq_product_id}</td>
				    				<td>${productVO.sq_brand_id}</td>
				    				<td>${productVO.product_kind_name}</td>
				   					<td>${productVO.stock_total}</td>
				   					<td>${productVO.product_name}</td>
				   					<td>${productVO.product_price}</td>
				   					<td>
				   						<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter${productVO.sq_product_id}">�Ϥ�</button>
                                        <div class="modal fade" id="exampleModalCenter${productVO.sq_product_id}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                                        	<div class="modal-dialog modal-dialog-centered" role="document">
                                            	<div class="modal-content">
                                                	<div class="modal-header">
                                                     	<h5 class="modal-title" id="exampleModalCenterTitle">�ӫ~��</h5>
                                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        	<span aria-hidden="true">&times;</span>
                                                       	</button>
                                                    </div>
	                                                <div class="modal-body">
	                                                	<img src="/EA101G4/showImg?id=${productVO.sq_product_id}" class="img-fluid">
	                                                </div>
	                                                <div class="modal-footer">
	                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	                                                </div>
                                           		</div>
                                            </div>
                                        </div>
				   					</td>
				   					<td>
				   						<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter${productVO.product_detail}">����</button>
                                        <div class="modal fade" id="exampleModalCenter${productVO.product_detail}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                                        	<div class="modal-dialog modal-dialog-centered" role="document">
                                            	<div class="modal-content">
                                                	<div class="modal-header">
                                                     	<h5 class="modal-title" id="exampleModalCenterTitle">�ӫ~��</h5>
                                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        	<span aria-hidden="true">&times;</span>
                                                       	</button>
                                                    </div>
	                                                <div class="modal-body">
	                                                	<span>${productVO.product_detail}</span>
	                                                </div>
	                                                <div class="modal-footer">
	                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	                                                </div>
                                           		</div>
                                            </div>
                                        </div>
				   					</td>
				   					<td>${productVO.product_model}</td>
				   					<td>${productVO.product_color}</td>
				   					<td>${productVO.add_date}</td>
				   					<td>
				   						<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModalCenter${productVO.product_material}">����</button>
                                        <div class="modal fade" id="exampleModalCenter${productVO.product_material}" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
                                        	<div class="modal-dialog modal-dialog-centered" role="document">
                                            	<div class="modal-content">
                                                	<div class="modal-header">
                                                     	<h5 class="modal-title" id="exampleModalCenterTitle">�ӫ~��</h5>
                                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                                        	<span aria-hidden="true">&times;</span>
                                                       	</button>
                                                    </div>
	                                                <div class="modal-body">
	                                                	<span>${productVO.product_material}</span>
	                                                </div>
	                                                <div class="modal-footer">
	                                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
	                                                </div>
                                           		</div>
                                            </div>
                                        </div>
				   					</td>
				   					<td>${productVO.product_status}</td>              
				    				<td style="text-align: left;">${brandVO.brand_detail}</td>
				    				<td>
				    					<FORM METHOD="post" ACTION="brand.do" style="position: relative;">
										    <input type="submit" value="�ק�" style="position: absolute; opacity: 0;">
										    <img src="image/changeicon.png" alt="" class="img-fluid">
										    <input type="hidden" name="sq_brand_id"  value="${brandVO.sq_brand_id}">
										    <input type="hidden" name="action"	value="getOneForUpdate">
										</FORM>
				    				</td>
				    				<td>
										 <FORM METHOD="post" ACTION="brand.do" style="position: relative;">
										   	<input type="submit" value="�R��" style="position: absolute; opacity: 0;">
										    <img src="image/delicon.png" alt="" class="img-fluid">
									    	<input type="hidden" name="sq_brand_id" value="${brandVO.sq_brand_id}">
									    	<input type="hidden" name="action" value="delete">
									    </FORM>
									</td>
				    			</tr>
				    		</c:forEach>			
    					</table>
    				</div>
    			</div>
    		</div>
		</div>
	
	
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<%@ include file="/back-end/backFrame/backFooter" %>