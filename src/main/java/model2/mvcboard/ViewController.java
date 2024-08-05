package model2.mvcboard;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ViewController
 */
@WebServlet("/view.do")
public class ViewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 게시물 불러오기
        MVCBoardDAO dao = new MVCBoardDAO(); //dao 생성
        String idx = request.getParameter("idx"); //글번호
        
        //조회수 증가
//      dao.updateVisitCount(idx); 과거 방식
     // 이미 조회한 게시물인지 확인하는 쿠키가 있는지 확인
        Cookie[] cookies = request.getCookies();
        boolean Visited = false; //기본값
        if (cookies != null) { //클라이언트가 관련 쿠키가 있으면 확인
            for (Cookie c : cookies) { //방문한적있는 게시글 확인
                if (c.getName().equals("post_" + idx) && c.getValue().equals("visited")) {
                    Visited = true; //조회한적 있는 글이면 True
                    break;
                }
            }
        }
        if (!Visited) { //조회한적 없는 글이면
            // 조회수 증가 메소드 호출
            dao.updateVisitCount(idx);
            // 새 쿠키 설정
            Cookie visitCookie = new Cookie("post_" + idx, "visited");
            visitCookie.setPath(request.getContextPath());
            visitCookie.setMaxAge(60 * 60 * 24); // 1일
            response.addCookie(visitCookie);
        }
        
        MVCBoardDTO dto = dao.selectView(idx); //상세정보
        dao.close();
        // 줄바꿈문자를 <br>로 변경
        dto.setContent(dto.getContent().replaceAll("\r\n", "<br/>"));

        request.setAttribute("dto", dto); //attribute name "dto"에 dto를 저장
        request.getRequestDispatcher("/View.jsp").forward(request, response); //포워딩. 주소 변경 안됨.
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
