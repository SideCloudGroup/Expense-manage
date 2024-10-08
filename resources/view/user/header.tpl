<header class="navbar navbar-expand-md">
    <div class="container-xl">
        <button class="navbar-toggler collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#navbar-menu"
                aria-controls="navbar-menu" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbar-menu">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="/">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-house"></i>
                        </span>
                        <span class="nav-link-title">
                            首页
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/user/item/add">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-cash-register"></i>
                        </span>
                        <span class="nav-link-title">
                            发起收款
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/user/item">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-file-invoice-dollar"></i>
                        </span>
                        <span class="nav-link-title">
                            我创建的收款
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/user/payment">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-receipt"></i>
                        </span>
                        <span class="nav-link-title">
                            需支付的款项
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/user/unpaid">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-calculator"></i>
                        </span>
                        <span class="nav-link-title">
                            查看总未支付
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/user/currency">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-arrow-right-arrow-left"></i>
                        </span>
                        <span class="nav-link-title">
                            查询当前汇率
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/user/profile">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-user"></i>
                        </span>
                        <span class="nav-link-title">
                            个人信息
                        </span>
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <button class="btn btn-danger" hx-get="/user/logout" hx-trigger="click" hx-target="body">
                        <span class="nav-link-icon d-md-none d-lg-inline-block">
                            <i class="fa-solid fa-sign-out-alt"></i>
                        </span>
                        <span class="nav-link-title">
                            登出
                        </span>
                    </button>
                </li>
            </ul>
        </div>
    </div>
</header>