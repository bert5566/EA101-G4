<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
								<!-----------backHeader----------->
<%@include file="/back-end/backFrame/backHeader"%>
								<!-----------backHeader----------->
<!-- --------------------------------------------------------------------------------------------->    
  

                               <!---------放自己的CSS與title----------->



<!-- --------------------------------------------------------------------------------------------->  
								<!-----------backBody----------->

 <%@include file="/back-end/backFrame/backBody"%>

								<!-----------backBody----------->
<!-- --------------------------------------------------------------------------------------------->
<!--分頁自己改-->

				<div class="row" style="background-color: white;">
					<ul class="nav nav-tabs">
					  <li class="nav-item">
					    <a class="nav-link active" href="#"><span style="padding-bottom:8px; border-bottom: 3px blue solid;">item1</span></a><!--在哪一個頁面就哪加active和span的style-->
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="#"><span>item2</span></a>
					  </li>
					  <li class="nav-item">
					    <a class="nav-link" href="#"><span>item3</span></a>
					  </li>
					</ul>
				</div>	
<!--分頁自己改-->
<!-- --------------------------------------------------------------------------------------------->
								<!-----------backNav----------->
	<%@include file="/back-end/backFrame/backNav"%>

								<!-----------backNav----------->
<!-- --------------------------------------------------------------------------------------------->					
		<div class="container">
			<div class="row">
				<div class="col">
					租車管理
				</div>
				<div class="col">
					訂單管理
				</div>
			</div>
		</div>


			


<!-- --------------------------------------------------------------------------------------------->
								<!-----------backFooter----------->

	<%@include file="/back-end/backFrame/backFooter"%>
 			