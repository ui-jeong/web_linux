<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@page import="java.sql.*" %>
<%request.setCharacterEncoding("utf-8");%>
<%@page import="bean.postDAO" %>
<jsp:useBean id="pb" class="bean.PostDatabasebean"/>
<jsp:setProperty name="pb" property="*"/>

<!DOCTYPE html>
<html>
<head>
<meta content="text/html" charset="utf-8">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script>
<%
	postDAO pd = new postDAO();
	int like=0;
	int star=0;
	String number_like="";
	String number_star="";
	String sql2="";
%>

$(document).ready(function(){
	<%//살짝 꼼수를 쓴 버튼 구현 
	 //자바스크립트의 변수가 jsp로 전달이 안되어서 버튼 클릭하면 페이지에 query 전달해서
	//페이지 reload, 다른 방법이 있다면 고쳐봅시다 +session을 써서 한번 버튼을 누르면 다시 못누르게 할 수 있을 듯 합니다....
		number_like=request.getParameter("number_like");
		number_star=request.getParameter("number_star");
		if (number_like!=null){
			sql2="update post set likes=likes+1 where number='"+number_like+"'";
			pd.upload(sql2);
		}
		if (number_star!=null){
			sql2="update post set bookmarks=bookmarks+1 where number='"+number_star+"'";
			pd.upload(sql2);
		}
	%>
    $("#searchbutton").click(function(event){
    	var keyword=$(".searchtext").val();
    	window.location.href=encodeURI("UserPage.jsp?search="+keyword);
    });
    $('.like').click(function(){
    	var num=$(this).attr("id");
    	window.location.href=encodeURI("UserPage.jsp?number_like="+num);
    	<%
		sql2="";
		like+=1;
		%>
    });
    $('.star').click(function(){
    	var num=$(this).attr("id");
    	window.location.href=encodeURI("UserPage.jsp?number_star="+num);
    	<%
		sql2="";
		star+=1;
		%>
    });
    
})
</script>
<title>전주 mypage</title>
<link rel="stylesheet" type="text/css" href="css/NewFile.css">
</head>
<body>
<div id="container">
    <jsp:include page="UserPage/header.jsp" flush="false"/>
    <jsp:include page="UserPage/UserInfo.jsp" flush="false"/>
    <section class="Userback">
    	<div class="title">
    		<img class="bigMenu" id="내가 쓴 글" src="images/paper.png" width="27px" height="27px"></img>
    		<b><font size="5">&nbsp;내가 쓴 글</font></b>
    	</div>
    	<div align="right">
    		<button class="btn-2" onClick="location.href='UploadPage.jsp'">새로운 글쓰기</button>
    	</div>
    	<br>
    	<div class="searchwindow">
    		<input type="text" class="searchtext" value=""/>
    		<button id="searchbutton" type="button" class="search">search</button>
    	</div>
    	<br><br>
    	<div class="myPost">
    	<br>
    	<table id="user-table">
    		<tbody>
    		<tr>
    		<%
    			String search=request.getParameter("search");
    			//나중에 아이디에 해당하는 게시글만 가져오기 위해 세션의 현재 사용자의 아이디를 확인하고 이와 일치하는
    			//게시글 만을 가져오도록 sql 조정할것!!
    			//String id=(String)session.getAttribute("id");
    			int count=0;
    			ResultSet rs=null;
    			String sql="";
    			if (search==null)
    				sql="select * from post";
    			else
    				sql="select * from post where content like '%"+search+"%' or title like'%"+search+"%'";
    			rs=pd.getResult(sql);
    			while(rs.next()){
    				count++;
    				if (count%3!=1&&count!=1){
    		%>
				<td><div class="table_content">
					<div class="userID" align="left" style="font-size:14px;"><b><%=rs.getString("id") %></b></div>
					<img src="images/ds.jpg" width="240px" height="180px"><br>
					<div class="title"style="font-size:13px;"><%=rs.getString("title") %></div>
					<div class="buttons">
					<button class="like" id="<%=rs.getString("number") %>" name="like" ><img width="15px" src="images/thumb-up-button.png"></button>
					<button class="star" id="<%=rs.getString("number") %>" name="star"><img width="15px" src="images/star.png"></button>
					</div>
					<div class="content"style="font-size:13px;">
					<%
						String c=rs.getString("content");
						if (c.length()>30)//30자 이상이면 생략되도록
							c=c.substring(0,30)+"...";
						out.print(c);
					%>
					</div>
				</div></td>								
    			<%
    				}
    				else if(count%3==1){%>
    				</tr>
    				<tr>
	    				<td><div class="table_content">
						<div class="userID" align="left" style="font-size:14px;"><b><%=rs.getString("id") %></b></div>
						<img src="images/ds.jpg" width="240px" height="180px"><br>
						<div class="title"style="font-size:13px;"><%=rs.getString("title") %></div>
						<div class="buttons" id="<%=rs.getString("id") %>">
						<button id="<%=rs.getString("number") %>" class="like" name="like"><img width="15px" src="images/thumb-up-button.png"></button>
						<button id="<%=rs.getString("number") %>" class="star" name="star"><img width="15px" src="images/star.png"></button>
						</div>
						<div class="content" style="font-size:13px;">
						<%
							String c=rs.getString("content"); 
							if (c.length()>30)//30자 이상이면 생략되도록
								c=c.substring(0,30)+"...";
							out.print(c);
						%>
						</div>
					</div></td>
    			<%
    				}
    			}
    			%>
    			</tr>
    		</tbody>
    	</table>
    	</div>
    </section>
</div>
</body>
</html>