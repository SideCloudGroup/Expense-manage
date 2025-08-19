<!-- 侧边栏 -->
<aside class="navbar navbar-vertical navbar-expand-lg" data-bs-theme="auto">
    <div class="container-fluid">
        <div class="navbar-brand navbar-brand-autodark w-100 d-flex">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#sidebar-menu"
                    aria-controls="sidebar-menu" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <a class="navbar-brand mx-auto" href="/">
                <i class="fa-solid fa-coins me-2"></i>
                {:getSetting('general_name')}
            </a>
        </div>
        
        <!-- 侧边栏导航 -->
        <div class="collapse navbar-collapse" id="sidebar-menu">
            <ul class="navbar-nav pt-lg-3">
                <li class="nav-item">
                    <a class="nav-link" href="/">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-house"></i>
                        </span>
                        <span class="nav-link-title">首页</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/item/add">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-cash-register"></i>
                        </span>
                        <span class="nav-link-title">发起收款</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/item">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                        </span>
                        <span class="nav-link-title">我创建的收款</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/payment">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-receipt"></i>
                        </span>
                        <span class="nav-link-title">需支付的款项</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/invoice">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-calculator"></i>
                        </span>
                        <span class="nav-link-title">查看总未支付</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/currency">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-arrow-right-arrow-left"></i>
                        </span>
                        <span class="nav-link-title">查询当前汇率</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/party">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-users"></i>
                        </span>
                        <span class="nav-link-title">我的派对</span>
                    </a>
                </li>
                
                <li class="nav-item">
                    <a class="nav-link" href="/user/profile">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-user"></i>
                        </span>
                        <span class="nav-link-title">个人信息</span>
                    </a>
                </li>
                
                {if app()->userService->getUser()->is_admin}
                <li class="nav-item">
                    <a class="nav-link" href="/admin">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-cog"></i>
                        </span>
                        <span class="nav-link-title">管理界面</span>
                    </a>
                </li>
                {/if}
            </ul>
            
            <!-- 主题切换按钮 -->
            <div class="nav-item mt-auto mb-2">
                <button class="btn btn-outline-primary w-100" id="theme-toggle" title="切换主题">
                    <i class="fa-solid fa-moon me-2" id="theme-icon"></i>
                    切换主题
                </button>
            </div>
            
            <!-- 登出按钮 -->
            <a class="nav-item btn btn-danger w-100 mb-1" href="#" hx-get="/user/logout" hx-trigger="click" hx-target="body">
                <i class="fa-solid fa-sign-out-alt me-2"></i>
                登出
            </a>
        </div>
    </div>
</aside>

<!-- 主题切换脚本 -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const themeToggle = document.getElementById('theme-toggle');
    const themeIcon = document.getElementById('theme-icon');
    
    // 获取当前主题
    function getCurrentTheme() {
        return document.documentElement.getAttribute('data-bs-theme') || 'light';
    }
    
    // 设置主题
    function setTheme(theme) {
        document.documentElement.setAttribute('data-bs-theme', theme);
        localStorage.setItem('theme', theme);
        
        // 更新图标
        if (theme === 'dark') {
            themeIcon.className = 'fa-solid fa-sun me-2';
            themeToggle.title = '切换到亮色模式';
        } else {
            themeIcon.className = 'fa-solid fa-moon me-2';
            themeToggle.title = '切换到暗色模式';
        }
    }
    
    // 切换主题
    function toggleTheme() {
        const currentTheme = getCurrentTheme();
        const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
        setTheme(newTheme);
    }
    
    // 初始化主题
    function initTheme() {
        // 优先使用用户保存的主题
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            setTheme(savedTheme);
        } else {
            // 如果没有保存的主题，检查系统偏好
            if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
                setTheme('dark');
            } else {
                setTheme('light');
            }
        }
    }
    
    // 监听系统主题变化
    if (window.matchMedia) {
        window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function(e) {
            // 只有在用户没有手动设置主题时才跟随系统
            if (!localStorage.getItem('theme')) {
                setTheme(e.matches ? 'dark' : 'light');
            }
        });
    }
    
    // 绑定事件
    themeToggle.addEventListener('click', toggleTheme);
    
    // 初始化
    initTheme();
});
</script>