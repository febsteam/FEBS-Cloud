package cc.mrbird.febs.auth.handler;

import cc.mrbird.febs.common.core.entity.FebsResponse;
import cc.mrbird.febs.common.core.utils.FebsUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author MrBird
 */
@Slf4j
@Component
public class FebsWebLoginFailureHandler implements AuthenticationFailureHandler {
    @Override
    public void onAuthenticationFailure(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, AuthenticationException exception) throws IOException {
        String message;
        int status;

        if (exception instanceof BadCredentialsException) {
            status = HttpServletResponse.SC_UNAUTHORIZED;
            message = "用户名或密码错误！";
        } else if (exception instanceof LockedException) {
            status = HttpServletResponse.SC_FORBIDDEN;
            message = "用户已被锁定！";
        } else {
            status = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
            message = "认证失败，请联系网站管理员！";
        }
        log.error(exception.getMessage());
        FebsUtil.makeFailureResponse(httpServletResponse, status, new FebsResponse().message(message));
    }
}
