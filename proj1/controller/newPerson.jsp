<HTML>
<HEAD>
<TITLE>Your Insert Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*"%>
<% 
	if((request.getParameter("newperson") != null) || (request.getParameter("newuserskip") != null))
        {		
			//get the oracle user account
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd =  (String)session.getAttribute("SQLPASSWD");
		    
	        String firstName= "";
	        String lastName = "";
	        String personid = "";
	        Integer personID= null;
	        String address  = "";
	        String email    = "";
	        String phone    = "";
	        
	        //if the new user is already registed, and he pressed skip
	        if (request.getParameter("newuserskip") != null){
	        	String skip = (request.getParameter("newuserskip"));
	        	session.setAttribute("newuserskip",skip);
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='../view/addUser.html'\""+", 0);");
		    	out.println("</script>");
	        }
	        //if the new user do not provide person ID, return bad response
	        else if ((request.getParameter("personid") == "")){
	        	out.println("<div style='background: url(10.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        	out.println("<BR><BR>");
	        	out.println("<BR><p><CENTER><b>Insert Failed!</b></CENTER></p>");
	        	out.println("<BR><p><CENTER><b>Please provide your Person ID!</b></CENTER></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='../view/addPerson.html'\""+", 2500);");
		    	out.println("</script></div>");
	        }
	        else{
	        	String skip = null;
	        	session.setAttribute("newuserskip",skip);
	        	
		        //get the user input
		        firstName= (request.getParameter("firstname"));
		        lastName = (request.getParameter("lastname"));
		        personid = (request.getParameter("personid"));
	          try{
		        personID= Integer.parseInt(personid);
	          } catch (Exception ex) {
	        	  out.println("<hr><center>" + ex.getMessage()+"teeeeeeeeeeeest" + "</center><hr>");
	          }
		        address  = (request.getParameter("address"));
		        email    = (request.getParameter("emailid"));
		        phone    = (request.getParameter("mobileno"));
		        session.setAttribute("personid",personID); 

		        
		        //establish the connection to the underlying database
	        	Connection conn = null;
		
		        String driverName = "oracle.jdbc.driver.OracleDriver";
	            String dbstring = "jdbc:oracle:thin:@gwynne.cs.ualberta.ca:1521:CRS";
		
	   	        try{
	   		        //load and register the driver
	           		Class drvClass = Class.forName(driverName); 
	   	        	DriverManager.registerDriver((Driver) drvClass.newInstance());
	           	}
	   	        catch(Exception ex){
	   		        if ((ex.getMessage()).length() > 100)
		        		out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        		else
	        			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	   	
	   	        }
		
	        	try{
		        	//establish the connection 
			        conn = DriverManager.getConnection(dbstring,sqlname,sqlpwd);
	        		conn.setAutoCommit(false);
		        }
	        	catch(Exception ex){
			        if ((ex.getMessage()).length() > 100)
		        		out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        		else
	        			out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        	}
		
	
		        //Insert all person Information to DB
	        	PreparedStatement pstmt = null;
	 
	        	
	        	try{
	        		pstmt = conn.prepareStatement("INSERT INTO persons (person_id, first_name,last_name,address,email,phone)"
	        				  +"VALUES(?, ?, ?, ?, ?, ?)");
	      			pstmt.setInt(1, personID);
	      			pstmt.setString(2, firstName);
	      			pstmt.setString(3, lastName);
	      			pstmt.setString(4, address);
	      			pstmt.setString(5, email );
	      			pstmt.setString(6, phone );
			    	pstmt.executeQuery();
	
			    	out.println("<div style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
			    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='../view/addUser.html'\""+", 1000);");
			    	out.println("</script></div>");
	        	}
	
		        catch(Exception ex){
		        	out.println("<div style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		        	out.println("<BR><p><CENTER>Insert Failed!</CENTER></p><br><br>");
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
			    	out.println("<script language=javascript type=text/javascript>");
			    	out.println("setTimeout("+"\"javascript:location.href='../view/addPerson.html'\""+", 2500);");
			    	out.println("</script>");
			        out.println("</div>");
	            }
	
	            try{
	                    conn.close();
	            }
	            catch(Exception ex){
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	            }
	        }
        }
  
%>


</BODY>
</HTML>

