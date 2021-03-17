package cc.mrbird.febs.server.system.service.impl;

import cc.mrbird.febs.common.core.entity.MenuTree;
import cc.mrbird.febs.common.core.entity.Tree;
import cc.mrbird.febs.common.core.entity.constant.PageConstant;
import cc.mrbird.febs.common.core.entity.constant.StringConstant;
import cc.mrbird.febs.common.core.entity.router.RouterMeta;
import cc.mrbird.febs.common.core.entity.router.VueRouter;
import cc.mrbird.febs.common.core.entity.system.Menu;
import cc.mrbird.febs.common.core.exception.FebsException;
import cc.mrbird.febs.common.core.utils.FebsUtil;
import cc.mrbird.febs.common.core.utils.TreeUtil;
import cc.mrbird.febs.server.system.mapper.MenuMapper;
import cc.mrbird.febs.server.system.service.IMenuService;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @author MrBird
 */
@Slf4j
@Service("menuService")
@Transactional(propagation = Propagation.SUPPORTS, readOnly = true)
public class MenuServiceImpl extends ServiceImpl<MenuMapper, Menu> implements IMenuService {

    @Override
    public String findUserPermissions(String username) {
        checkUser(username);
        List<Menu> userPermissions = this.baseMapper.findUserPermissions(username);
        return userPermissions.stream().map(Menu::getPerms).collect(Collectors.joining(StringConstant.COMMA));
    }

    @Override
    public List<Menu> findUserMenus(String username) {
        checkUser(username);
        return this.baseMapper.findUserMenus(username);
    }

    @Override
    public Map<String, Object> findMenus(Menu menu) {
        Map<String, Object> result = new HashMap<>(4);
        try {
            LambdaQueryWrapper<Menu> queryWrapper = new LambdaQueryWrapper<>();
            queryWrapper.orderByAsc(Menu::getOrderNum);
            List<Menu> menus = baseMapper.selectList(queryWrapper);

            List<MenuTree> trees = new ArrayList<>();
            buildTrees(trees, menus);

            if (StringUtils.equals(menu.getType(), Menu.TYPE_BUTTON)) {
                result.put(PageConstant.ROWS, trees);
            } else {
                List<? extends Tree<?>> menuTree = TreeUtil.build(trees);
                result.put(PageConstant.ROWS, menuTree);
            }

            result.put("total", menus.size());
        } catch (NumberFormatException e) {
            log.error("查询菜单失败", e);
            result.put(PageConstant.ROWS, null);
            result.put(PageConstant.TOTAL, 0);
        }
        return result;
    }

    @Override
    public List<VueRouter<Menu>> getUserRouters(String username) {
        checkUser(username);
        List<VueRouter<Menu>> routes = new ArrayList<>();
        List<Menu> menus = this.findUserMenus(username);
        menus.forEach(menu -> {
            VueRouter<Menu> route = new VueRouter<>();
            route.setId(menu.getMenuId().toString());
            route.setParentId(menu.getParentId().toString());
            route.setPath(menu.getPath());
            route.setComponent(menu.getComponent());
            route.setName(menu.getMenuName());
            route.setMeta(new RouterMeta(menu.getMenuName(), menu.getIcon(), true));
            routes.add(route);
        });
        return TreeUtil.buildVueRouter(routes);
    }


    @Override
    public List<Menu> findMenuList(Menu menu) {
        LambdaQueryWrapper<Menu> queryWrapper = new LambdaQueryWrapper<>();
        if (StringUtils.isNotBlank(menu.getMenuName())) {
            queryWrapper.like(Menu::getMenuName, menu.getMenuName());
        }
        queryWrapper.orderByAsc(Menu::getMenuId);
        return this.baseMapper.selectList(queryWrapper);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void createMenu(Menu menu) {
        menu.setCreateTime(new Date());
        setMenu(menu);
        this.save(menu);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void updateMenu(Menu menu) {
        menu.setModifyTime(new Date());
        setMenu(menu);
        baseMapper.updateById(menu);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void deleteMeuns(String[] menuIds) {
        this.delete(Arrays.asList(menuIds));
    }

    private void buildTrees(List<MenuTree> trees, List<Menu> menus) {
        menus.forEach(menu -> {
            MenuTree tree = new MenuTree();
            tree.setId(menu.getMenuId().toString());
            tree.setParentId(menu.getParentId().toString());
            tree.setLabel(menu.getMenuName());
            tree.setComponent(menu.getComponent());
            tree.setIcon(menu.getIcon());
            tree.setOrderNum(menu.getOrderNum());
            tree.setPath(menu.getPath());
            tree.setType(menu.getType());
            tree.setPerms(menu.getPerms());
            trees.add(tree);
        });
    }

    private void setMenu(Menu menu) {
        if (menu.getParentId() == null) {
            menu.setParentId(Menu.TOP_MENU_ID);
        }
        if (Menu.TYPE_BUTTON.equals(menu.getType())) {
            menu.setPath(null);
            menu.setIcon(null);
            menu.setComponent(null);
            menu.setOrderNum(null);
        }
    }

    private void delete(List<String> menuIds) {
        removeByIds(menuIds);

        LambdaQueryWrapper<Menu> queryWrapper = new LambdaQueryWrapper<>();
        queryWrapper.in(Menu::getParentId, menuIds);
        List<Menu> menus = baseMapper.selectList(queryWrapper);
        if (CollectionUtils.isNotEmpty(menus)) {
            List<String> menuIdList = new ArrayList<>();
            menus.forEach(m -> menuIdList.add(String.valueOf(m.getMenuId())));
            this.delete(menuIdList);
        }
    }

    private void checkUser(String username) {
        String currentUsername = FebsUtil.getCurrentUsername();
        if (StringUtils.isNotBlank(currentUsername)
                && !StringUtils.equalsIgnoreCase(currentUsername, username)) {
            throw new FebsException("无权获取别的用户数据");
        }
    }

}
