<HTML>
<HEAD>
<TITLE>Your Search Result</TITLE>
</HEAD>

<BODY>

<%@page import="java.sql.*" import= "java.util.*"%>
<% 
	if (request.getParameter(".submit") != null)
        {			
		    String sqlname = (String)session.getAttribute("SQLUSERID");
		    String sqlpwd  = (String)session.getAttribute("SQLPASSWD");
			Integer rid    = (Integer)session.getAttribute("rid");
			
			//get the user input from the login page
			String patientId=  (request.getParameter("patientList")).trim();
			String doctorId =  (request.getParameter("doctorList")).trim();
	        Integer patientID =  Integer.parseInt(patientId);
	        Integer doctorID =   Integer.parseInt(doctorId);
	        String testType =  (request.getParameter("testtype")).trim();
	        String diagnosis=  (request.getParameter("diagnosis")).trim();
	        String description=(request.getParameter("description")).trim();
		    int rec_id;
			
        	
        	java.util.Date myDate = new java.util.Date();
	        java.sql.Date sqlDate = new java.sql.Date(myDate.getTime());
	        
	        /**
        	out.println("<p><CENTER>sqlname = "+sqlname+"</CENTER></p>");
        	out.println("<p><CENTER>sqlpswd = "+sqlpwd+"</CENTER></p>");
        	out.println("<p><CENTER>rid = "+rid+"</CENTER></p>");
	       */
	       
	        /**
        	out.println("<p><CENTER>patientId = "+patientId+"</CENTER></p>");
        	out.println("<p><CENTER>doctorId = "+doctorId+"</CENTER></p>");
        	out.println("<p><CENTER>testType = "+testType+"</CENTER></p>");
        	out.println("<p><CENTER>diagnosis = "+diagnosis+"</CENTER></p>");
        	out.println("<p><CENTER>description = "+description+"</CENTER></p>");
        	out.println("<p><CENTER>sqlDate = "+sqlDate+"</CENTER></p>");
        	*/
	        
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
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
	        }

        	try{
	        	//establish the connection 
		        conn = DriverManager.getConnection(dbstring,sqlname,sqlpwd);
        		conn.setAutoCommit(false);
	        }
        	catch(Exception ex){
		        out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}
        	
        	PreparedStatement pstmt = null;
	        Statement stmt = null;
	        ResultSet rset = null;      
        	
	        //insert into radiology_record
        	try{
        		stmt = conn.createStatement();
        		//out.println("<p><CENTER>1 "+ "I am in this line" +"</CENTER></p>");
	    	    rset = stmt.executeQuery("select record_id from radiology_record"); // I need to select how many a
	    	    //out.println("<p><CENTER>2 "+ "I am in this line" +"</CENTER></p>");
	    	    rset.next();
	    	    //out.println("<p><CENTER>3 "+ "I am in this line" +"</CENTER></p>");
	    	    rec_id = rset.getInt(1)+1;
	    	    //out.println("<p><CENTER>4 "+ "I am in this line" +"</CENTER></p>");
	    	    
	    	    session.setAttribute("rec_id = ",rec_id);
	    	    out.println("<p><CENTER>rec_id: "+rec_id+"</CENTER></p>");
	    	    
        		pstmt = conn.prepareStatement("INSERT INTO radiology_record (record_id,patient_id,doctor_id,radiologist_id,test_type,prescribing_date,test_date,diagnosis,description)"
        				  +"VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)");
      			pstmt.setInt(1, rec_id);
      			pstmt.setInt(2, patientID);
      			pstmt.setInt(3, doctorID);
      			pstmt.setInt(4, rid);
      			pstmt.setString(5, testType );
      			pstmt.setDate(6, sqlDate );
      			pstmt.setDate(7, sqlDate );
      			pstmt.setString(8, diagnosis);
      			pstmt.setString(9, description);
		    	pstmt.executeQuery();

		    	out.println("<div style='background: url(../theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
		    	out.println("<BR><p><CENTER><b>Insert Successful!</b></CENTER></p>");
		    	out.println("<BR><p><CENTER><b>Next, you are going to upload an image!</b></CENTER></p>");
		    	out.println("<script language=javascript type=text/javascript>");
		    	out.println("setTimeout("+"\"javascript:location.href='../view/uploadImg.html'\""+", 1000);");
		    	out.println("</script></div>");
        	}

	        catch(Exception ex){
	        	//out.println("<div style='background: url(theme.jpg) no-repeat; width: 100%; height: 100%; background-size: 100%;'>");
	        	//out.println("<BR><p><CENTER>Insert Failed!</CENTER></p><br><br>");
		        if ((ex.getMessage()).length() > 100) {
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
		        }
	        	else {
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>"); 
	        	}
		    	//out.println("<script language=javascript type=text/javascript>");
		    	//out.println("setTimeout("+"\"javascript:location.href='uploadRecord.jsp'\""+", 2500);");
		    	//out.println("</script>");
		        //out.println("</div>");
		        conn.rollback();
            }
            try{
                conn.close();
        	}
       		catch(Exception ex){
                if ((ex.getMessage()).length() > 100)
		        	out.println("<hr><center>" + (ex.getMessage()).substring(11,12+48) + "</center><hr>");
	        	else
	        		out.println("<hr><center>" + ex.getMessage() + "</center><hr>");
        	}

        }

  
%>



</BODY>
</HTML>