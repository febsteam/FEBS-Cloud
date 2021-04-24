package cc.mrbird.febs.auth.translator;

import cc.mrbird.febs.common.core.entity.FebsResponse;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.common.exceptions.*;
import org.springframework.security.oauth2.provider.error.WebResponseExceptionTranslator;
import org.springframework.stereotype.Component;

/**
 * 异常翻译
 *
 * @author MrBird
 */
@Slf4j
@Component
@SuppressWarnings("all")
public class FebsWebResponseExceptionTranslator implements WebResponseExceptionTranslator {

    @Override
    public ResponseEntity<?> translate(Exception e) {
        String message = "认证失败：";
        ResponseEntity.BodyBuilder status = ResponseEntity.status(HttpStatus.UNAUTHORIZED);

        if (e instanceof UnsupportedGrantTypeException) {
            message += "不支持该认证类型";
            status = ResponseEntity.status(HttpStatus.BAD_REQUEST);
        }
        else if (e instanceof InvalidTokenException
                && StringUtils.containsIgnoreCase(e.getMessage(), "Invalid refresh token (expired)")) {
            message += "刷新令牌已过期，请重新登录";
        }
        else if (e instanceof InvalidGrantException) {
            if (StringUtils.containsIgnoreCase(e.getMessage(), "Invalid refresh token")) {
                message += "refresh token无效";
            }
            else if (StringUtils.containsIgnoreCase(e.getMessage(), "Invalid authorization code")) {
                String code = StringUtils.substringAfterLast(e.getMessage(), ": ");
                message += "授权码" + code + "不合法";
            }
            else if (StringUtils.containsIgnoreCase(e.getMessage(), "locked")) {
                message += "用户已被锁定，请联系管理员";
                status = ResponseEntity.status(HttpStatus.FORBIDDEN);
            }
            else {
                message += "用户名或密码错误";
            }
        }
        else {
            if (e instanceof InvalidScopeException) {
                message += "不是有效的scope值";
            }
            else if (e instanceof RedirectMismatchException) {
                message += "redirect_uri值不正确";
            }
            else if (e instanceof BadClientCredentialsException) {
                message += "client值不合法";
            }
            else if (e instanceof UnsupportedResponseTypeException) {
                String code = StringUtils.substringBetween(e.getMessage(), "[", "]");
                message += code + "不是合法的response_type值";
            }
            else {
                message += "服务器未知错误";
            }
            status = ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR);
            message += e;
        }

        log.error(message);
        return status.body(new FebsResponse().message(message));
    }
}
