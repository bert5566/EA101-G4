package com.filter;

import java.io.*;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.staff.model.StaffVO;

public class StaffLoginFilter implements Filter{

	private FilterConfig config;
	public void init(FilterConfig config) {	  
		this.config = config;
	}

	public void destroy() {
		config = null;
	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws ServletException, IOException {
		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;
		
		HttpSession session = req.getSession();	// 【取得 session】
		StaffVO StaffVO = (com.staff.model.StaffVO) session.getAttribute("StaffVO");	// 【從 session 判斷此user是否登入過】
		if (StaffVO == null) {
			res.sendRedirect(req.getContextPath() + "/back-end/LoginStaff.jsp");
			return;
		} else {
			chain.doFilter(request, response);
		}
	}
}