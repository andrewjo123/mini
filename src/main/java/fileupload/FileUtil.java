package fileupload;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;

public class FileUtil {
	//파일업로드처리
	public static MultipartRequest uploadFile(HttpServletRequest request,String saveDirectory,int maxPostSize) {
		try {
			return new MultipartRequest(request,saveDirectory,maxPostSize, "UTF-8");
		}catch(Exception e) {
			e.printStackTrace();			
			return null;
		}
	}
	//다운로드처리
	public static void download(HttpServletRequest request, HttpServletResponse response,
			String directory,String sfileName, String ofileName) {
		//업로드폴더 실제경로
		String sDirectory=request.getServletContext().getRealPath(directory);
		try {
			File file=new File(sDirectory,sfileName); // 저장된 파일을 가리키는 파일객체생성
			InputStream iStream=new FileInputStream(file); // 파일에서 읽기(입력)
			//한글파일명 인코딩
			ofileName=new String(ofileName.getBytes("UTF-8"),"ISO-8859-1");
			
			//파일다운로드를 위해서 헤더설정
			response.reset();
			response.setContentType("application/octet-stream"); // pdf, 이미지파일등도 다운로드 되도록 설정
			response.setHeader("Content-Disposition", "attachment; filename=\""+ofileName+"\"");//다운로드파일명설정
			response.setHeader("Content-Length", ""+file.length());
			
			OutputStream oStream=response.getOutputStream();//출력스트림. 브라우저로 보내기 위해
			byte[] b=new byte[1024]; //파일크기만큼 버퍼생성
			int readBuffer=0; //읽어온 크기를 저장하는 변수
			while((readBuffer=iStream.read(b))>0) { // 버퍼크기만큼씩 읽어서 버퍼에 저장. 읽어온 데이터가 있으면
				oStream.write(b,0,readBuffer); // 출력
			}
			iStream.close();
			oStream.close();
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
    // 파일삭제
    public static void deleteFile(HttpServletRequest request,String directory,String filename) {
        //업로드폴더 절대경로
    	String sDirectory = request.getServletContext().getRealPath(directory);
    	//파일 reference 생성
        File file = new File(sDirectory + File.separator + filename);
        if (file.exists()) {
            file.delete();
        }
    }
}
