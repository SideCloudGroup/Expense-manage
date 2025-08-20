{include file="admin/header"}

<title>管理后台 - 数据概览</title>

<div class="page">
    <div class="page-wrapper">
        <div class="page-body">
            <div class="container-xl">
                <!-- 页面标题 -->
                <div class="page-header d-print-none">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">系统数据概览</h2>
                            <div class="text-muted mt-1">实时监控系统运行状态和关键指标</div>
                        </div>
                    </div>
                </div>

                <!-- 统计卡片 -->
                <div class="row row-deck row-cards">


                    <!-- 用户统计 -->
                    <div class="col-sm-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="subheader">用户总数</div>
                                </div>
                                <div class="h1 mb-3">{$totalUsers}</div>
                                <div class="d-flex mb-2">
                                    <div>管理员: {$adminUsers}</div>
                                    <div class="ms-auto">
                                        <span class="text-blue d-inline-flex align-items-center lh-1">
                                            普通用户: {$regularUsers}
                                        </span>
                                    </div>
                                </div>
                                <div class="progress progress-sm" style="height: 3px;">
                                    <div class="progress-bar bg-blue" style="width: {$userActivityRate}%"></div>
                                </div>
                                <div class="text-muted">活跃用户: {$activeUsers} ({$userActivityRate}%)</div>
                            </div>
                        </div>
                    </div>

                    <!-- 项目统计 -->
                    <div class="col-sm-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="subheader">项目总数</div>
                                </div>
                                <div class="h1 mb-3">{$totalItems}</div>
                                <div class="d-flex mb-2">
                                    <div>已支付: {$paidItems}</div>
                                    <div class="ms-auto">
                                        <span class="text-warning d-inline-flex align-items-center lh-1">
                                            未支付: {$unpaidItems}
                                        </span>
                                    </div>
                                </div>
                                <div class="progress progress-sm" style="height: 3px;">
                                    <div class="progress-bar bg-warning"
                                         style="width: {($unpaidItems/$totalItems)*100}%"></div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <!-- 派对统计 -->
                    <div class="col-sm-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex align-items-center">
                                    <div class="subheader">派对总数</div>
                                </div>
                                <div class="h1 mb-3">{$totalParties}</div>
                                <div class="d-flex mb-2">
                                    <div>活跃派对: {$activeParties}</div>
                                    <div class="ms-auto">
                                        <span class="text-purple d-inline-flex align-items-center lh-1">
                                            单人社群: {$totalParties-$activeParties}
                                        </span>
                                    </div>
                                </div>
                                <div class="progress progress-sm" style="height: 3px;">
                                    <div class="progress-bar bg-purple" style="width: {$partyActivityRate}%"></div>
                                </div>
                                <div class="text-muted">活跃度: {$partyActivityRate}%</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}