package cc.mrbird.febs.common.entity.constant;

/**
 * @author MrBird
 */
public class SocialConstant {

    public static final String SOCIAL_LOGIN = "social_login";
    private static final ThreadLocal<String> threadLocal = new ThreadLocal<>();

    /**
     * 获取随机生成的密码
     * @return
     */
    public static String getSocialLoginPassword() {
        return threadLocal.get();
    }

    /**
     * 设置随机生成的密码
     * @param socialLoginPassword
     */
    public static void setSocialLoginPassword(String socialLoginPassword) {
        threadLocal.set(socialLoginPassword);
        //防止内存泄漏
        threadLocal.remove();
    }
}
