<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!-----------backHeader----------->
<%@include file="/back-end/backFrame/backHeader"%>
<!-----------backHeader----------->
<!-- --------------------------------------------------------------------------------------------->


<!---------放自己的CSS與title----------->


<!-- --------------------------------------------------------------------------------------------->
<!-----------backBody----------->

<%@include file="/back-end/backFrame/masterBackBody"%>

<!-----------backBody----------->
<!-- --------------------------------------------------------------------------------------------->
<!--分頁自己改-->

<div class="row" style="background-color: white;">
	<ul class="nav nav-tabs">
		<li class="nav-item "><a class="nav-link" href="<%=request.getContextPath()%>/back-end/bike/bikeTypeListAll.jsp"><span>車種管理</span></a>
		<!--在哪一個頁面就哪加active和span的style--></li>
		<li class="nav-item "><a class="nav-link" href="<%=request.getContextPath()%>/back-end/bike/newBikeListAll.jsp"><span>車輛管理</span></a>
		</li>
		<li class="nav-item"><a class="nav-link active" data-toggle="collapse" href="#collapseExample" role="button" aria-expanded="false" aria-controls="collapseExample"><span style="padding-bottom: 8px; border-bottom: 3px blue solid;">訂單管理</span></a>
		</li>
		<li class="nav-item"><a class="nav-link active" href="<%=request.getContextPath()%>/bike/BikeStoreServlet.do?action=bikeStoreOwner&sq_bike_store_id=${BikeStoreVO.sq_bike_store_id}" ><span>店家資訊</span></a>
		</li>
	</ul>
</div>
<div class="container-fluid">
	
</div>
<!--分頁自己改-->
<!-- --------------------------------------------------------------------------------------------->
<!-----------backNav----------->
<%@include file="/back-end/backFrame/masterBackNav"%>

<!-----------backNav----------->
<!-- --------------------------------------------------------------------------------------------->
<div class="container-fluid mx-3">
	<div class="row collapse" id="collapseExample">
		<div class="col-1"></div>
		<div class="col-6 my-1">
			<button class="btn bg-primary mx-2" onclick="location.href='<%=request.getContextPath()%>/back-end/bike/bikeMaster.jsp'">訂單(未取車)</button>
			<button class="btn bg-primary mx-2" onclick="location.href='<%=request.getContextPath()%>/back-end/bike/MasterEx.jsp'">訂單(已取車,未還車)</button> 
			<button class="btn bg-primary mx-2" onclick="location.href='<%=request.getContextPath()%>/back-end/bike/bikeRentHistory.jsp'">歷史訂單</button>
		</div>
	</div>
	<div class="row">
		<table class="table text-center table-hover">
			<thead>
				<tr>
					<th scope="col">訂單編號</th>
					<th scope="col">姓名</th>
					<th scope="col">電話</th>
					<th scope="col">訂單狀態</th>
					<th scope="col">還車日期</th>
					<th scope="col">綠界交易編號</th>
					<th scope="col">查看明細</th>
				</tr>
			</thead>
			<tbody id="masterTbody">
					
			</tbody>
		</table>
	</div>
</div>
<div class="modal fade" id="DetailModel" tabindex="-1" role="dialog"  aria-labelledby="basicModal" >
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
				
			<div class="modal-header">
                <h3 class="modal-title" id="myModalLabel">訂單成立</h3>
            </div>
			
			<div class="modal-body">
<!-- =========================================以下為原bikeDetailResv.jsp的內容========================================== -->
<%--                <jsp:include page="bikeDetailResv.jsp" /> --%>
<!-- =========================================以上為原bikeDetailResv.jsp的內容========================================== -->
			</div>
			
			<div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">返回</button>
            </div>
		
		</div>
	</div>
</div>
<script src="<%=request.getContextPath()%>/datetimepicker/jquery.js"></script>
<script
src="<%=request.getContextPath()%>/datetimepicker/jquery.datetimepicker.full.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	
// 	modal暫時解法
	$(".modal").on("shown.bs.modal", function () {
	    if ($(".modal-backdrop").length > 1) {
	        $(".modal-backdrop").not(':first').remove();
	    }
	})
	
	//initValue
	$.ajax({
		url:"<%=request.getContextPath()%>/bike/BikeRentDetailServlet.do",
		type :"POST",
		data : {
			action:"initExMaster",
		},
		dataType: "JSON",
		success : function(data) {
			 handleJSON(data);
		},complete:function(){
			//查看submit
			$(".btn-sub").click(function(){
				var sq_rent_id = $(this).closest("tr").find("td").eq(0).text();
				//狀態為未租車
					$.ajax({
						url:"<%=request.getContextPath()%>/bike/BikeRentDetailServlet.do",
						type :"POST",
						data : {
							action:"initEx",
							sq_rent_id : sq_rent_id,
						},
						success:function(){
							$(".modal-body").load("bikeDetailEx.jsp");
						}
					})
			})
			
		}
	})
	
	//搜尋單個編號
	$("#searchRentIdBtn").click(function(){
		var sq_rent_id = $("#searchRentId").val();
		$.ajax({
			type:"POST",
			url:"<%=request.getContextPath()%>/bike/BikeRentDetailServlet.do",
			data:{
				action:"searchResvRentId",
				sq_rent_id:sq_rent_id,
			},
			dataType:"JSON",
			success:function(data){
				handleJSON(data);
			},complete:function(){
				//查看submit
				$(".btn-sub").click(function(){
					var sq_rent_id = $(this).closest("tr").find("td").eq(0).text();
					//狀態為未租車
						$.ajax({
							url:"<%=request.getContextPath()%>/bike/BikeRentDetailServlet.do",
							type :"POST",
							data : {
								action:"initResv",
								sq_rent_id : sq_rent_id,
							},
							success:function(){
								$(".modal-body").load("bikeDetailResv.jsp");
							},
						})
				})
			}
		})
	})
	
})


//處理回傳的JSON table
function handleJSON(data){
	var storeMasterList = data.storeMaster;
	var str = "";
	for(var i =0 ; i<storeMasterList.length;i++){
		var storeMaster = storeMasterList[i];
		var sq_rent_id = storeMaster.sq_rent_id;
		var rent_name = storeMaster.rent_name;
		var rent_phone = storeMaster.rent_phone;
		var rent_od_status = storeMaster.rent_od_status;
		//取得訂單狀態中文
		var rent_od_statusStr = getValue(rent_od_status);
		//訂單時間
		var order_date = data.resvTime[sq_rent_id];
		var order_date_spilt = order_date.split(" ");
		var tradeno = storeMaster.tradeno;
		str+="<tr>";
		str+="<td>"+sq_rent_id+"</td>";
		str+="<td>"+rent_name+"</td>";
		str+="<td>"+rent_phone+"</td>";
		str+="<td class='text-danger'>"+rent_od_statusStr+"</td>";
		str+="<td>"+order_date_spilt[0]+"</td>";
		str+="<td>"+tradeno+"</td>";
		str+="<td><button class='btn btn-sm btn-primary btn-sub' type='button' data-toggle='modal' data-target='#DetailModel'>查看</button></td>";
		str+="</tr>";
	}
	$("#masterTbody").html(str);
}



function getValue(rent_od_status){
	switch (rent_od_status) {
	  case 0:
		  return "訂單成立";
	      break;
	  case 1:
		  return "訂單進行";
	      break;
	  case 2:
		  return "訂單完成";
	      break;
	  case 3:
		  return "訂單取消";
	      break;
	}
}
</script>


<!-- --------------------------------------------------------------------------------------------->
<!-----------backFooter----------->

<%@include file="/back-end/backFrame/backFooter"%>