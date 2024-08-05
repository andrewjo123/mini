package model2.mvcboard;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;

import fileupload.FileUtil;
import utils.JSFunction;

/**
 * Servlet implementation class WriteController
 */
@WebServlet("/write.do")
public class WriteController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WriteController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/Write.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 폼에 입력한 한글 인코딩처리. 깨짐방지
		request.setCharacterEncoding("UTF-8");
		
		//파일업로드 처리
		String saveDirectory=request.getServletContext().getRealPath("/Uploads");
		System.out.println(saveDirectory);
		int maxPostSize=5*1024*1024; // 첨부파일 최대크기 5Mbyte로 지정.
		MultipartRequest mr=FileUtil.uploadFile(request, saveDirectory, maxPostSize);//파일업로드
	    if(mr==null) {
	    	JSFunction.alertLocation(response, "첨부파일이 제한 용량을 초과합니다", "/write.do");
	    	return;
	    }		
		
		// 폼에 입력한 값을 dto에 저장
		MVCBoardDTO dto=new MVCBoardDTO();
		dto.setName(mr.getParameter("name"));
		dto.setTitle(mr.getParameter("title"));
		dto.setContent(mr.getParameter("content"));
		dto.setPass(mr.getParameter("pass"));
		
		//업로드된 원본파일명을 변경해서 중복방지
		String fileName=mr.getFilesystemName("ofile");
		if(fileName!=null) {
			String now=new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
			String ext=fileName.substring(fileName.lastIndexOf(".")); //확장자구하기
			String newFileName=now+ext; //새로운 파일명 만들기
			File oldFile=new File(saveDirectory+File.separator+fileName);
			File newFile=new File(saveDirectory+File.separator+newFileName);
			oldFile.renameTo(newFile); //파일명변경
			
			dto.setOfile(fileName);//원래 파일명
			dto.setSfile(newFileName);//새 파일명
		}
		
		// dao생성
		MVCBoardDAO dao=new MVCBoardDAO();
		int result=dao.insertWrite(dto); // dto를 parameter값으로 전달
		dao.close(); // close작업
		
		if(result==1) {//영향을 받은 행의 수가 1이면. insert가 정상적으로 실행된 경우.
			response.sendRedirect("/list.do"); // 목록으로
		}else {
			response.sendRedirect("/write.do"); // 등록으로
		}
	}

}
