package com.member.controller;

import java.io.IOException;

import java.sql.*;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.*;

import java.io.*;

import com.mail.MailService;
import com.member.model.MemDAO;
import com.member.model.MemService;
import com.member.model.MemVO;

import redis.clients.jedis.Jedis;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 5 * 5 * 1024 * 1024)

public class MemServlet extends HttpServlet {

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		doPost(req, res);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		Jedis jedis = new Jedis("localhost", 6379);
		jedis.auth("123456");
		req.setCharacterEncoding("UTF-8");
		String action = req.getParameter("action");
		HttpSession session = req.getSession();

		

		if ("getOne_For_Display".equals(action)) { // 來自select_page.jsp的請求

			List<String> errorMsgs = new LinkedList<String>();
			// Store this set in the request scope, in case we need to
			// send the ErrorPage view.
			req.setAttribute("errorMsgs", errorMsgs);

			try {
				/*************************** 1.接收請求參數 - 輸入格式的錯誤處理 **********************/
				String str = req.getParameter("sq_member_id");
				if (str == null || (str.trim()).length() == 0) {
					errorMsgs.add("請輸入會員編號");
				}
				// Send the use back to the form, if there were errors
				if (!errorMsgs.isEmpty()) {
					RequestDispatcher failureView = req.getRequestDispatcher("/back-end/member/selectMember_page.jsp");
					failureView.forward(req, res);
					return;// 程式中斷
				}

				String sq_member_id = null;
				try {
					sq_member_id = new String(str);
				} catch (Exception e) {
					errorMsgs.add("會員編號格式不正確");
				}
				// Send the use back to the form, if there were errors
				if (!errorMsgs.isEmpty()) {
					RequestDispatcher failureView = req.getRequestDispatcher("/front-end/member/selectMember_page.jsp");
					failureView.forward(req, res);
					return;// 程式中斷
				}

				/*************************** 2.開始查詢資料 *****************************************/
				MemService memSvc = new MemService();
				MemVO memVO = memSvc.findByPrimaryKey(sq_member_id);
				if (memVO == null) {
					errorMsgs.add("查無資料");
				}
				// Send the use back to the form, if there were errors
				if (!errorMsgs.isEmpty()) {
					RequestDispatcher failureView = req.getRequestDispatcher("/front-end/member/selectMember_page.jsp");
					failureView.forward(req, res);
					return;// 程式中斷
				}

				/*************************** 3.查詢完成,準備轉交(Send the Success view) *************/
				req.setAttribute("memVO", memVO); // 資料庫取出的empVO物件,存入req
				String url = "/back-end/member/listOneMember.jsp";
				RequestDispatcher successView = req.getRequestDispatcher(url); // 成功轉交 listOneEmp.jsp
				successView.forward(req, res);

				/*************************** 其他可能的錯誤處理 *************************************/
			} catch (Exception e) {
				errorMsgs.add("無法取得資料:" + e.getMessage());
				RequestDispatcher failureView = req.getRequestDispatcher("/back-end/member/selectMember_page.jsp");
				failureView.forward(req, res);
			}
		}
		if ("getOne_For_Update_back".equals(action)) { // 來自listAllMem.jsp的請求

			Map<String,String> errorMsgs = new HashMap<>();
			// Store this set in the request scope, in case we need to
			// send the ErrorPage view.
			req.setAttribute("errorMsgs", errorMsgs);

			try {
				/*************************** 1.接收請求參數 ****************************************/
				String sq_member_id = req.getParameter("sq_member_id");
				
				/*************************** 2.開始查詢資料 ****************************************/
				MemService memSvc = new MemService();
				MemVO memVO = memSvc.findByPrimaryKey(sq_member_id);
				req.setAttribute("MemVO", memVO); // 資料庫取出的memVO物件,存入req
				/*************************** 3.查詢完成,準備轉交(Send the Success view) ************/
				
				//會員後台
					String url = "/back-end/member/listOneMember.jsp";
					RequestDispatcher successView = req.getRequestDispatcher(url);// 成功轉交 update_emp_input.jsp
					successView.forward(req, res);
				
				/*************************** 其他可能的錯誤處理 **********************************/
			}catch(Exception ce) {
				ce.printStackTrace();
			}
		}

		if ("update".equals(action) || "update_back".equals(action)) { // 來自update_member_input.jsp的請求

			Map<String,String> errorMsgs = new HashMap<>();
			// Store this set in the request scope, in case we need to
			// send the ErrorPage view.
			req.setAttribute("errorMsgs", errorMsgs);

			try {
				/*************************** 1.接收請求參數 - 輸入格式的錯誤處理 **********************/
				String sq_member_id = new String(req.getParameter("sq_member_id").trim());

				String m_name = req.getParameter("m_name");
				String m_nameReg = "^[(\u4e00-\u9fa5)(a-zA-Z0-9_)]{2,16}$";

				// {2,10} 此程式為UTF-8編碼 中文字長度為3個btye? 若輸入4個字(12byte)則超過10 會產生錯誤(前端攔不住此錯誤)
				if (m_name == null || m_name.trim().length() == 0) {
					errorMsgs.put("m_name", "姓名: 請勿空白");
				} else if (!m_name.trim().matches(m_nameReg)) { // 以下練習正則(規)表示式(regular-expression)
					errorMsgs.put("m_name", "姓名: 只能是中、英文字母、數字和_ , 且長度必需在2到16之間");
				}

				String member_account = req.getParameter("member_account").trim();
				if (member_account == null || member_account.trim().length() == 0) {
					errorMsgs.put("member_account", "帳號請勿空白");
				}

				String password = req.getParameter("password").trim();
				if (password == null || password.trim().length() == 0) {
					errorMsgs.put("password", "密碼請勿空白");
				}

				String cellphone = req.getParameter("cellphone").trim();
				if (cellphone == null || cellphone.trim().length() == 0) {
					errorMsgs.put("phone", "電話請勿空白");
				}

				java.sql.Date birthday = null;
				try {
					birthday = java.sql.Date.valueOf(req.getParameter("birthday"));
				} catch (IllegalArgumentException e) {
					birthday = new java.sql.Date(System.currentTimeMillis());
					errorMsgs.put("birthday", "請輸入日期!");
				} catch (NullPointerException nu) {
					errorMsgs.put("birthday", "請輸入日期!");
				}

				String m_email = req.getParameter("m_email").trim();
				if (m_email == null || m_email.trim().length() == 0) {
					errorMsgs.put("m_email", "請輸入email");
				}

				String address = req.getParameter("address").trim();
				if (address == null || address.trim().length() == 0) {
					errorMsgs.put("address", "請輸入聯絡地址");
				}
				Integer validation = 1;
				Integer gender = new Integer(req.getParameter("gender"));
				
				Date registered = new java.sql.Date(System.currentTimeMillis());

				Part m_photor = req.getPart("m_photo");
				InputStream in = m_photor.getInputStream();
				byte[] m_photo = null;
				m_photo = new byte[in.available()];
				in.read(m_photo);
				in.close();
				
				
				MemService memSvc = new MemService();
				MemVO memVO = memSvc.findByPrimaryKey(sq_member_id);
				
				memVO.setMember_account(member_account);	
				memVO.setPassword(password);
				memVO.setM_name(m_name);
				memVO.setGender(gender);
				memVO.setBirthday(birthday);
				memVO.setCellphone(cellphone);
				memVO.setM_email(m_email);
				memVO.setRegistered(registered);
				memVO.setValidation(validation);
				if(m_photor.getSize() != 0) {
					memVO.setM_photo(m_photo);
				}
				
				memVO.setBack_img(null);
				memVO.setNick_name(null);
				memVO.setAddress(address);
				

				// Send the use back to the form, if there were errors
				if (!errorMsgs.isEmpty()) {
					req.setAttribute("memVO", memVO); // 含有輸入格式錯誤的empVO物件,也存入req
					RequestDispatcher failureView = req
							.getRequestDispatcher("/front-end/member/listOneMem.jsp");
					failureView.forward(req, res);
					return; // 程式中斷
				}
				/*************************** 2.開始修改資料 *****************************************/
				memSvc.updateMem(memVO);
				
				/*************************** 3.修改完成,準備轉交(Send the Success view) *************/
				if("update".equals(action)) {
				session.setAttribute("MemVO", memVO); // 資料庫update成功後,正確的的empVO物件,存入req
				String url = "/front-end/member/listOneMem.jsp";
				RequestDispatcher successView = req.getRequestDispatcher(url); // 修改成功後,轉交listOneEmp.jsp
				successView.forward(req, res);
				}
				
				if("update_back".equals(action)) {
					String url = "/back-end/member/listAllMember.jsp";
					RequestDispatcher successView = req.getRequestDispatcher(url); // 修改成功後,轉交listOneEmp.jsp
					successView.forward(req, res);
				}
				/*************************** 其他可能的錯誤處理 *************************************/

			} catch (Exception e) {
				e.printStackTrace();
				errorMsgs.put("errorMsg","修改資料失敗:" + e.getMessage());
				RequestDispatcher failureView = req.getRequestDispatcher("/front-end/member/listOneMem.jsp");
				failureView.forward(req, res);
			}
		}
		/////update --end

		if ("insert".equals(action)) { // 來自addEmp.jsp的請求

			Map<String, String> errorMsgs = new HashMap<>();

			req.setAttribute("errorMsgs", errorMsgs);

			try {
				/*********************** 1.接收請求參數 - 輸入格式的錯誤處理 *************************/
				String m_name = req.getParameter("m_name");
				String m_nameReg = "^[(\u4e00-\u9fa5)(a-zA-Z0-9_)]{2,16}$";

				// {2,10} 此程式為UTF-8編碼 中文字長度為3個btye? 若輸入4個字(12byte)則超過10 會產生錯誤(前端攔不住此錯誤)
				if (m_name == null || m_name.trim().length() == 0) {
					errorMsgs.put("m_name", "姓名: 請勿空白");
				} else if (!m_name.trim().matches(m_nameReg)) { // 以下練習正則(規)表示式(regular-expression)
					errorMsgs.put("m_name", "姓名: 只能是中、英文字母、數字和_ , 且長度必需在2到16之間");
				}

				String member_account = req.getParameter("member_account").trim();
				if (member_account == null || member_account.trim().length() == 0) {
					errorMsgs.put("member_account", "帳號請勿空白");
				}

				String password = req.getParameter("password").trim();
				if (password == null || password.trim().length() == 0) {
					errorMsgs.put("password", "密碼請勿空白");
				}

				String cellphone = req.getParameter("cellphone").trim();
				if (cellphone == null || cellphone.trim().length() == 0) {
					errorMsgs.put("phone", "電話請勿空白");
				}

				java.sql.Date birthday = null;
				try {
					birthday = java.sql.Date.valueOf(req.getParameter("birthday"));
				} catch (IllegalArgumentException e) {
					birthday = new java.sql.Date(System.currentTimeMillis());
					errorMsgs.put("birthday", "請輸入日期!");
				} catch (NullPointerException nu) {
					errorMsgs.put("birthday", "請輸入日期!");
				}

				String m_email = req.getParameter("m_email").trim();
				if (m_email == null || m_email.trim().length() == 0) {
					errorMsgs.put("m_email", "請輸入email");
				}

				String address = req.getParameter("address").trim();
				if (address == null || address.trim().length() == 0) {
					errorMsgs.put("address", "請輸入聯絡地址");
				}

				Integer validation = new Integer(req.getParameter("validation"));

				Integer gender = new Integer(req.getParameter("gender"));

				Date registered = new java.sql.Date(System.currentTimeMillis());

				Part m_photor = req.getPart("m_photo");
				InputStream in = m_photor.getInputStream();
				byte[] m_photo = null;
				if (in.available() == 0) {
					if (session.getAttribute("m_photo") == null) {
						errorMsgs.put("m_photo", "頭相未選擇上傳圖片");
					} else {
						m_photo = (byte[]) session.getAttribute("m_photo");
						in.read(m_photo);
						in.close();
					}
				} else {
					m_photo = new byte[in.available()];
					session.setAttribute("m_photo", m_photo);
					in.read(m_photo);
					in.close();
				}

				MemVO memVO = new MemVO();

				memVO.setMember_account(member_account);
				memVO.setPassword(password);
				memVO.setM_name(m_name);
				memVO.setGender(gender);
				memVO.setBirthday(birthday);
				memVO.setCellphone(cellphone);
				memVO.setM_email(m_email);
				memVO.setValidation(validation);
				memVO.setRegistered(registered);
				memVO.setM_photo(m_photo);
				memVO.setBack_img(null);
				memVO.setNick_name(null);
				memVO.setAddress(address);
				
				//判斷帳號是否有重複
				MemService memSvc = new MemService();
				List<MemVO> listall = memSvc.getAll();
				for(MemVO MemVO : listall ) {
					if(MemVO.getMember_account().equals(member_account)) {
						errorMsgs.put("member_account", "帳號已被使用，請重新輸入");
					}
				}

				// Send the use back to the form, if there were errors
				if (!errorMsgs.isEmpty()) {
					req.setAttribute("memVO", memVO); // 含有輸入格式錯誤的empVO物件,也存入req
					RequestDispatcher failureView = req.getRequestDispatcher("/front-end/member/registered.jsp");
					failureView.forward(req, res);
					return; // 程式中斷
				}

				/*************************** 2.開始新增資料 ***************************************/
				memVO = memSvc.addMem(member_account, password, m_name, gender, birthday, cellphone, m_email,
						validation, registered, m_photo, null, null, address);
				
				//寄信
				email(member_account ,m_email , req );
				/*************************** 3.新增完成,準備轉交(Send the Success view) ***********/
				String url = req.getContextPath()+"/front-end/member/registered.jsp?validation=email";
				res.sendRedirect(url);
				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				e.printStackTrace();
				RequestDispatcher failureView = req.getRequestDispatcher("/front-end/member/registered.jsp");
				failureView.forward(req, res);
			}
		}
		
//驗證信回來
		if("validation".equals(action)) {
			String mail_rand = req.getParameter("rand");
			String member_account = req.getParameter("member_account");
			
			//redis 取資料比對
			String rand = jedis.get(member_account);
			if(mail_rand.equals(rand)) {
				//更改會員狀態已認證
				MemService memSvc = new MemService();
				MemVO MemVO = memSvc.getOneMemfromAccount(member_account);
				MemVO.setValidation(1);
				memSvc.updateMem(MemVO);
				//登入會員轉移首頁
				session.setAttribute("MemVO", MemVO);
				String url = req.getContextPath()+"/front-end/index/index.jsp?validation=success";
				res.sendRedirect(url);
			}
		}

		if ("delete".equals(action)) { // 來自listAllEmp.jsp

			List<String> errorMsgs = new LinkedList<String>();
			// Store this set in the request scope, in case we need to
			// send the ErrorPage view.
			req.setAttribute("errorMsgs", errorMsgs);
			String requestURL = req.getParameter("requestURL");
			try {
				/*************************** 1.接收請求參數 ***************************************/
				String sq_member_id = new String(req.getParameter("sq_member_id"));

				/*************************** 2.開始刪除資料 ***************************************/
				MemService memSvc = new MemService();
				MemVO memVO = memSvc.findByPrimaryKey(sq_member_id);
				memSvc.deleteMem(sq_member_id);

				/*************************** 3.刪除完成,準備轉交(Send the Success view) ***********/
				String url = "/back-end/member/listAllMember.jsp";
				RequestDispatcher successView = req.getRequestDispatcher(url);// 刪除成功後,轉交回送出刪除的來源網頁
				successView.forward(req, res);

				/*************************** 其他可能的錯誤處理 **********************************/
			} catch (Exception e) {
				errorMsgs.add("刪除資料失敗:" + e.getMessage());
				RequestDispatcher failureView = req.getRequestDispatcher("/back-end/member/listAllMember.jsp");
				failureView.forward(req, res);
			}
		}
	}

	public void email(String member_account,String mail,HttpServletRequest req) {
		Jedis jedis = new Jedis("localhost", 6379);
		jedis.auth("123456");
		// 產生亂碼
		String rand = rand();
		
		//存入redis
		jedis.set(member_account,rand);
		
		// 設定傳送郵件:至收信人的Email信箱,Email主旨,Email內容
		MailService MailSvc= new MailService();
//		至收信人的Email信箱,Email主旨,Email內容
	     String subject = "PAPAGO 會員驗證信(點擊前往)";
	     String dispatcher = req.getScheme()+"://"+req.getServerName()+":"+req.getServerPort()+req.getContextPath()+"/member/mem.do?action=validation&rand="+rand+"&member_account="+member_account;
		MailSvc.sendMail(mail, subject,dispatcher) ;
	}

	public String rand() {
		StringBuilder sb = new StringBuilder();
		for (int i = 1; i <= 8; i++) {
			int condition = (int) (Math.random() * 3) + 1;
			switch (condition) {
			case 1:
				char c1 = (char) ((int) (Math.random() * 26) + 65);
				sb.append(c1);
				break;
			case 2:
				char c2 = (char) ((int) (Math.random() * 26) + 97);
				sb.append(c2);
				break;
			case 3:
				sb.append((int) (Math.random() * 10));
			}
		}
		return sb.toString();
	}

}
