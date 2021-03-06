package com.bike.rent.detail.controller;

import static java.time.temporal.ChronoUnit.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.bike.bike.model.BikeService;
import com.bike.bike.model.BikeVO;
import com.bike.rent.detail.model.BikeRentDetailService;
import com.bike.rent.detail.model.BikeRentDetailVO;
import com.bike.rent.master.model.BikeRentMasterService;
import com.bike.rent.master.model.BikeRentMasterVO;
import com.bike.store.model.BikeStoreVO;
import com.bike.type.model.BikeTypeService;
import com.google.gson.Gson;


public class BikeRentDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html;charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		PrintWriter out = response.getWriter();
		String action = request.getParameter("action");
		HttpSession session = request.getSession();

		// initResv------------------------------------------------------------------------------------------
		if ("initResv".equals(action)) {
//上限改成session 取得店家id資料			
			BikeStoreVO BikeStoreVO = (BikeStoreVO)session.getAttribute("BikeStoreVO");
			String sq_bike_store_id = BikeStoreVO.getSq_bike_store_id();
			

			// 取訂單編號 如果是空值去session取 如果不是存進去包含空字串
			String sq_rent_id_Resv = null;
			String sq_rent_id = request.getParameter("sq_rent_id");
			if (sq_rent_id == null) {
				sq_rent_id_Resv = (String) session.getAttribute("sq_rent_id");
			} else {
				sq_rent_id_Resv = sq_rent_id;
				session.setAttribute("sq_rent_id", sq_rent_id);
			}

			// 取得初始參數
			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();// 先採取一張這個用不到
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();
			BikeTypeService bikeTypeSvc = new BikeTypeService();
			BikeService bikeSvc = new BikeService();
			List<BikeVO> bikeVOList = bikeSvc.getAll();
			List<BikeVO> storeBikeList = new ArrayList<>();
			// 先撈出店家車輛
			storeBikeList = bikeVOList.stream().filter(p -> p.getSq_bike_store_id().equals(sq_bike_store_id))
					.collect(Collectors.toList());


			// 所有訂單明細編號
			List<BikeRentDetailVO> bikeRentDetailList = bikeRentDetailSvc.getAll();

			// 找出這間店訂單明細VO 裝入list
			LinkedList<BikeRentDetailVO> storeRetailVOList = new LinkedList<>();

			for (BikeRentDetailVO BikeRentDetailVO : bikeRentDetailList) {
//					這間店的訂單編號 比對所有訂單明細編號 && 單車為空值
				if (sq_rent_id_Resv.equals(BikeRentDetailVO.getSq_rent_id())&& BikeRentDetailVO.getSq_bike_id() == null) {
					// 取消車輛不顯示
					if (!(BikeRentDetailVO.getSq_bike_type_id().equals("639999"))) {
						// 裝入比對到的單車車輛車種到這個list
						List<String> bikeTypeList = new ArrayList<>();
						for (BikeVO BikeVO : storeBikeList) {
							if (BikeRentDetailVO.getSq_bike_type_id().equals(BikeVO.getSq_bike_type_id())) {
								bikeTypeList.add(BikeVO.getSq_bike_id());
							}
						}
						// 把map裝入
						BikeRentDetailVO.setBikeTypeList(bikeTypeList);
						// 裝入車種名稱
						BikeRentDetailVO.setBikeTypeName(bikeTypeSvc
								.findByPrimaryKey(BikeRentDetailVO.getSq_bike_type_id()).getBike_type_name());
						storeRetailVOList.add(BikeRentDetailVO);
					}
				}

			}
			;
			Collections.sort(storeRetailVOList);
			// 傳回的JSON
			HashMap initMap = new HashMap();
			initMap.put("returnList", storeRetailVOList);
			JSONObject initJSONObject = new JSONObject(initMap);
			out.println(initJSONObject);
		}

		// 取消單車
		if ("deleteBike".equals(action)) {
			// 取訂單明細編號
			String sq_rent_detail_id = request.getParameter("sq_rent_detail_id");
			// 修改明細 新增單車物件
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();
			BikeRentDetailVO BikeRentDetailVO = bikeRentDetailSvc.findByPrimaryKey(sq_rent_detail_id);
			BikeRentDetailVO.setSq_bike_type_id("639999");
			bikeRentDetailSvc.update(BikeRentDetailVO);
		}

		// 接收單車進行修改
		if ("submitBike".equals(action)) {
			String jsonStr = request.getParameter("jsonStr");
			String sq_rent_id = request.getParameter("sq_rent_id");

			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();

			// 處理json資料
			try {
				JSONObject BikeorderObj = new JSONObject(jsonStr.trim());
				Iterator<String> keys = BikeorderObj.keys();
				while (keys.hasNext()) {
					String sq_rent_detail_id = keys.next();// 取出key sq_rent_detail_id
					String sq_bike_id = (String) BikeorderObj.get(sq_rent_detail_id);// 取出value sq_bike_id

					// 進行明細update
					BikeRentDetailVO BikeRentDetailVO = bikeRentDetailSvc.findByPrimaryKey(sq_rent_detail_id);
					BikeRentDetailVO.setSq_bike_id(sq_bike_id);
					bikeRentDetailSvc.update(BikeRentDetailVO);
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}

			// 訂單mater資訊更新
			BikeRentMasterVO BikeRentMasterVO = bikeRentMasterSvc.findByPrimaryKey(sq_rent_id);
			BikeRentMasterVO.setRent_od_status(1);
			bikeRentMasterSvc.update(BikeRentMasterVO);

		}
//ExPage------------------------------------------------------------------------------------------------------------------
		// initEx
		if ("initEx".equals(action)) {
			// 上限改成session 取得店家id資料
			BikeStoreVO BikeStoreVO = (BikeStoreVO)session.getAttribute("BikeStoreVO");
			String sq_bike_store_id = BikeStoreVO.getSq_bike_store_id();
			// 取訂單編號 如果是空值去session取 如果不是存進去包含空字串
			String sq_rent_id_Ex = null;
			String sq_rent_id = request.getParameter("sq_rent_id");
			if (sq_rent_id == null) {
				sq_rent_id_Ex = (String) session.getAttribute("sq_rent_id");
			} else {
				sq_rent_id_Ex = sq_rent_id;
				session.setAttribute("sq_rent_id", sq_rent_id);
			}
			// 取得初始參數
			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();
			BikeTypeService bikeTypeSvc = new BikeTypeService();
			// 找出是這間店的訂單
//			List<BikeRentMasterVO> storeRentIdList = bikeRentMasterSvc.getRentMasterIdIsVaild(sq_bike_store_id, 1);
			// 所有訂單明細編號
			List<BikeRentDetailVO> bikeRentDetailList = bikeRentDetailSvc.getAll();
		
			// 找出這間店訂單明細VO 裝入list
			LinkedList<BikeRentDetailVO> storeRetailVOList = new LinkedList<>();

			for (BikeRentDetailVO BikeRentDetailVO : bikeRentDetailList) {
					if (BikeRentDetailVO.getSq_rent_id().equals(sq_rent_id_Ex)
							&& BikeRentDetailVO.getSq_bike_id() != null) {
						// 裝入車種名稱
						BikeRentDetailVO.setBikeTypeName(bikeTypeSvc
								.findByPrimaryKey(BikeRentDetailVO.getSq_bike_type_id()).getBike_type_name());
						storeRetailVOList.add(BikeRentDetailVO);
					}
			}
			Collections.sort(storeRetailVOList);
			// 傳回的JSON
			HashMap initMap = new HashMap();
			initMap.put("returnList", storeRetailVOList);
			JSONObject initJSONObject = new JSONObject(initMap);
			out.println(initJSONObject);
		}

//MasterResvPage------------------------------------------------------------------------------------------------------------------
		if ("initResvMaster".equals(action)) {
			// 上限改成session 取得店家id資料
			BikeStoreVO BikeStoreVO = (BikeStoreVO)session.getAttribute("BikeStoreVO");
			String sq_bike_store_id = BikeStoreVO.getSq_bike_store_id();
			
			// 取得初始參數
			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();
			// 找出是這間店的訂單
			List<BikeRentMasterVO> storeRentList = bikeRentMasterSvc.getRentMasterIdIsVaild(sq_bike_store_id, 0);
			List<BikeRentMasterVO> storeMaster = null;
			storeMaster = storeRentList.stream().filter(p -> p.getSq_bike_store_id().equals(sq_bike_store_id))
					.collect(Collectors.toList());
			// 裝入還車時間
			Map<String, String> resvTime = new LinkedHashMap<>();
			
			List<BikeRentDetailVO> bikeRentDetailList = bikeRentDetailSvc.getAll();
			// 比對訂單跟明細的編號並找出出發時間
			for (BikeRentDetailVO BikeRentDetailVO : bikeRentDetailList) {
				for (BikeRentMasterVO BikeRentMasterVO : storeMaster) {
					if (BikeRentDetailVO.getSq_rent_id().equals(BikeRentMasterVO.getSq_rent_id())) {
						resvTime.put(BikeRentDetailVO.getSq_rent_id(),BikeRentDetailVO.getRsved_rent_date().toString());	
					}
				}
			}
			HashMap map = new HashMap();
			map.put("storeMaster", storeMaster);
			map.put("resvTime", resvTime);
			JSONObject responseJson = new JSONObject(map);
			out.println(responseJson);
		}
		

		if ("searchResvRentId".equals(action)) {
			// 上限改成session 取得店家id資料
			BikeStoreVO BikeStoreVO = (BikeStoreVO)session.getAttribute("BikeStoreVO");
			String sq_bike_store_id = BikeStoreVO.getSq_bike_store_id();
			String sq_rent_id = request.getParameter("sq_rent_id").trim();
			// 取得初始參數
			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();
			// 找出是這間店的訂單
//			List<BikeRentMasterVO> storeRentList = bikeRentMasterSvc.getRentMasterIdIsVaild(sq_bike_store_id, 0);
//			List<BikeRentMasterVO> storeMaster = null;
//			storeMaster = storeRentList.stream().filter(p -> p.getSq_bike_store_id().equals(sq_bike_store_id))
//					.collect(Collectors.toList());
			List<BikeRentMasterVO> storeMaster = Arrays.asList(bikeRentMasterSvc.findByPrimaryKey(sq_rent_id));
			// 裝入出發時間
			Map<String, String> resvTime = new LinkedHashMap<>();
			List<BikeRentDetailVO> bikeRentDetailList = bikeRentDetailSvc.getAll();
			// 比對訂單跟明細的編號並找出出發時間
			for (BikeRentDetailVO BikeRentDetailVO : bikeRentDetailList) {
				for (BikeRentMasterVO BikeRentMasterVO : storeMaster) {
					if (BikeRentDetailVO.getSq_rent_id().equals(BikeRentMasterVO.getSq_rent_id())) {
						resvTime.put(BikeRentDetailVO.getSq_rent_id(),
								BikeRentDetailVO.getRsved_rent_date().toString());
					}
				}
			}
			HashMap map = new HashMap();
			map.put("storeMaster", storeMaster);
			map.put("resvTime", resvTime);
			JSONObject responseJson = new JSONObject(map);
			out.println(responseJson);
		}
		
//		MasterEx--------------------------------------------------------------------------------------------------------------
		if ("initExMaster".equals(action)) {
			// 上限改成session 取得店家id資料
			BikeStoreVO BikeStoreVO = (BikeStoreVO)session.getAttribute("BikeStoreVO");
			String sq_bike_store_id = BikeStoreVO.getSq_bike_store_id();
			// 取得初始參數
			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();
			BikeRentDetailService bikeRentDetailSvc = new BikeRentDetailService();
			// 找出是這間店的訂單
			List<BikeRentMasterVO> storeRentList = bikeRentMasterSvc.getRentMasterIdIsVaild(sq_bike_store_id, 1);
			List<BikeRentMasterVO> storeMaster = null;
			storeMaster = storeRentList.stream().filter(p -> p.getSq_bike_store_id().equals(sq_bike_store_id))
					.collect(Collectors.toList());
			// 裝入回程時間
			Map<String, String> resvTime = new LinkedHashMap<>();
			List<BikeRentDetailVO> bikeRentDetailList = bikeRentDetailSvc.getAll();
			// 比對訂單跟明細的編號並找出出發時間
			for (BikeRentDetailVO BikeRentDetailVO : bikeRentDetailList) {
				for (BikeRentMasterVO BikeRentMasterVO : storeMaster) {
					if (BikeRentDetailVO.getSq_rent_id().equals(BikeRentMasterVO.getSq_rent_id())) {
						resvTime.put(BikeRentDetailVO.getSq_rent_id(),BikeRentDetailVO.getEx_return_date().toString());	
					}
				}
			}
			HashMap map = new HashMap();
			map.put("storeMaster", storeMaster);
			map.put("resvTime", resvTime);
			JSONObject responseJson = new JSONObject(map);
			out.println(responseJson);
		}
		
		//還車成功
		if ("returnBikes".equals(action)) {

			//接收參數 
			String jsonStr = request.getParameter("jsonStr");
			String sq_rent_id = request.getParameter("sq_rent_id");
			JSONArray bikeDetailJson = new JSONArray(jsonStr);
			
			BikeTypeService BikeTypeSvc = new BikeTypeService();
			BikeRentDetailService BikeRentDetailSvc = new BikeRentDetailService();
			BikeRentMasterService BikeRentMasterSvc = new BikeRentMasterService();
			BikeService BikeSvc = new BikeService();
			//時間格式
			DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
			//計算金額
			Integer total = 0;
			LocalDateTime now = LocalDateTime.now();
			//裝入回傳的資料
			HashMap map = new HashMap();
			
			for(int i =0 ; i <bikeDetailJson.length() ; i++) {
				JSONObject obj = bikeDetailJson.getJSONObject(i);
				String sq_rent_detail_id = obj.getString("sq_rent_detail_id");
				String sq_bike_id = obj.getString("sq_bike_id");
				Integer  bike_status = obj.getInt("sq_bike_status");
				Integer extra_cost = obj.getInt("extra_cost");
				//1.時間判斷時間有無超過多收錢  2.找出車種算錢 
				Integer singleExtraCost = 0;
				String ex_return_date = obj.getString("ex_return_date");
				LocalDateTime ex_return_dateFormat = LocalDateTime.parse(ex_return_date, formatter);
//				找出時間多久
				long untilHour = ex_return_dateFormat.until(now, HOURS);
				long untilDays = ex_return_dateFormat.until(now, DAYS);
				//找出單車價格多少*時間
				String bike_type_id = BikeSvc.findByPrimaryKey(sq_bike_id).getSq_bike_type_id();
				if(untilHour>0 && untilHour<6) {
					Integer hourPrice = BikeTypeSvc.findByPrimaryKey(bike_type_id).getBike_hourly_price();
					singleExtraCost = hourPrice * (int)untilHour;
				}else if(untilHour>6){
					//判斷如果是0天的話算一天
					untilDays = untilDays == 0 ? 1: untilDays;
					Integer dailyPrice = BikeTypeSvc.findByPrimaryKey(bike_type_id).getBike_daily_price();
					singleExtraCost = dailyPrice * (int)untilDays;
				}else {
					singleExtraCost = 0;
					untilHour = 0;
					untilDays = 0;
				}
				int hours = (int)untilHour%24; 
				map.put("untilHour",hours);
				map.put("untilDays",untilDays);
				
				
				//資料庫處理 1.單車物件 2.訂單明細 3.訂單
				BikeVO bikeVO = BikeSvc.findByPrimaryKey(sq_bike_id);
				bikeVO.setBike_status(bike_status);
				BikeSvc.update(bikeVO);
				
				BikeRentDetailVO BikeRentDetailVO = BikeRentDetailSvc.findByPrimaryKey(sq_rent_detail_id);
				BikeRentDetailVO.setReal_return_date(Timestamp.valueOf(now));
				BikeRentDetailVO.setExtra_cost(extra_cost+singleExtraCost);
				BikeRentDetailSvc.update(BikeRentDetailVO);
				
				//訂單總共金額
				total+=extra_cost+singleExtraCost;
			}
			
			BikeRentMasterVO BikeRentMasterVO =  BikeRentMasterSvc.findByPrimaryKey(sq_rent_id);
			BikeRentMasterVO.setOd_total_price(total);
			BikeRentMasterVO.setRent_od_status(2);
			BikeRentMasterSvc.update(BikeRentMasterVO);
			
			//回傳JSON
			map.put("total",total);
			JSONObject resJson = new JSONObject(map);
			out.println(resJson);
			
		}
		
//		history-------------------------------------------------------------
		if("initHistoryMaster".equals(action)) {
			BikeStoreVO BikeStoreVO = (BikeStoreVO)session.getAttribute("BikeStoreVO");
			String sq_bike_store_id = BikeStoreVO.getSq_bike_store_id();
			//回傳資料
			BikeRentMasterService bikeRentMasterSvc = new BikeRentMasterService();
			List<BikeRentMasterVO> bikeRentMasterList =bikeRentMasterSvc.getAll();
			// 找出是這間店完成和取消的訂單
			List<BikeRentMasterVO>
			storeMaster = bikeRentMasterList.stream()
					.filter(p -> p.getSq_bike_store_id().equals(sq_bike_store_id))
					.filter(p -> p.getRent_od_status()==2 || p.getRent_od_status()==3)
					.collect(Collectors.toList());
			HashMap map = new HashMap();
			map.put("storeMaster", storeMaster);
			JSONObject responseJson = new JSONObject(map);
			out.println(responseJson);
		}
	}
}

