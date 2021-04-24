package cc.mrbird.febs.auth.controller;

import cc.mrbird.febs.auth.manager.UserManager;
import cc.mrbird.febs.auth.service.ValidateCodeService;
import cc.mrbird.febs.common.core.entity.FebsResponse;
import cc.mrbird.febs.common.core.entity.constant.StringConstant;
import cc.mrbird.febs.common.core.exception.ValidateCodeException;
import cc.mrbird.febs.common.core.utils.FebsUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.oauth2.provider.token.ConsumerTokenServices;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.http.HttpResponse;
import java.security.Principal;

/**
 * @author MrBird
 */
@Slf4j
@Controller
@RequiredArgsConstructor
public class SecurityController {

    private final ValidateCodeService validateCodeService;
    private final UserManager userManager;
    private final ConsumerTokenServices consumerTokenServices;

    @ResponseBody
    @GetMapping("user")
    public Principal currentUser(Principal principal) {
        return principal;
    }

    @ResponseBody
    @GetMapping("captcha")
    public void captcha(HttpServletRequest request, HttpServletResponse response) throws IOException, ValidateCodeException {
        try {
            validateCodeService.create(request, response);
        } catch(Exception e) {
            FebsResponse febsResponse = new FebsResponse();
            FebsUtil.makeFailureResponse(response, HttpServletResponse.SC_BAD_REQUEST, febsResponse.message(e.getMessage()));
            log.error(e.getMessage());
        }
    }

    @RequestMapping("login")
    public String login() {
        return "login";
    }

    @ResponseBody
    @DeleteMapping("signout")
    public FebsResponse signout(HttpServletRequest request, @RequestHeader("Authorization") String token) {
        token = StringUtils.replace(token, "bearer ", StringConstant.EMPTY);
        consumerTokenServices.revokeToken(token);
        return new FebsResponse().message("signout");
    }
}
