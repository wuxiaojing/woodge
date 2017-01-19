public class Test{
	public static void main(String[] args){
		System.setProperty( "java.library.path", "/home/antispam/wuxiaojing/java/lib");
		System.out.println(""+ System.getProperty("java.class.path"));
	}
}
