{include file="/user/header"}
<title>{:getSetting('general_name')} - 首页</title>

<div class="page">
    <div class="page-wrapper">

            <!-- 欢迎信息 -->
            <div class="page-header d-print-none">
                <div class="row align-items-center justify-content-center">
                    <div class="col-auto">
                        <a href="https://www.bilibili.com/video/BV1ea4y1W7x1" target="_blank" title="关注永雏塔菲喵">
                            <img src="/static/imgs/taffynya_agadgqyaaofp2fq.png"
                                 style="width: 80px; height: 80px; object-fit: contain; cursor: pointer; transition: transform 0.2s ease;">
                        </a>
                    </div>
                    <div class="col-auto text-center mx-3">
                        <h2 class="page-title mb-1">你好喵，{$user.username}！</h2>
                        <div class="text-muted">
                            管理您的派对和财务
                        </div>
                    </div>
                    <div class="col-auto">
                        <a href="https://www.bilibili.com/video/BV1EF3uzeETo" target="_blank"
                           title="关注永雏塔菲谢谢喵">
                            <img src="/static/imgs/taffynya_agadvgmaauwawfq.png"
                                 style="width: 80px; height: 80px; object-fit: contain; cursor: pointer; transition: transform 0.2s ease;">
                        </a>
                    </div>
                </div>

                <!-- 快速操作按钮 -->
                <div class="row mt-3">
                    <div class="col-12 d-flex justify-content-center">
                        <div class="btn-list d-flex justify-content-center">
                            <a href="/user/item/add" class="btn btn-primary">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                                </svg>
                                添加收款项
                            </a>
                            <a href="/user/party" class="btn btn-secondary">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                </svg>
                                我的派对
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 统计卡片 -->
            <div class="row row-deck row-cards mt-3">
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">加入的派对</div>
                            </div>
                            <div class="h1 mb-3">{$stats.total_parties}</div>
                            <div class="d-flex mb-2">
                                <div>活跃派对数量</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">待支付金额</div>
                            </div>
                            <div class="h1 mb-3 text-danger">¥{$stats.total_unpaid_amount|default=0}</div>
                            <div class="d-flex mb-2">
                                <div>需要支付的款项</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">应收金额</div>
                            </div>
                            <div class="h1 mb-3 text-success">¥{$stats.total_receivable_amount|default=0}</div>
                            <div class="d-flex mb-2">
                                <div>等待收款的款项</div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-sm-6 col-lg-3">
                    <div class="card">
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                <div class="subheader">项目总数</div>
                            </div>
                            <div class="h1 mb-3 text-primary">{$stats.total_items|default=0}</div>
                            <div class="d-flex mb-2">
                                <div>创建 {$stats.total_items_created} / 支付 {$stats.total_items_to_pay}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 财务概览图表 -->
            <div class="row row-cards mt-3">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">财务概览</h3>
                        </div>
                        <div class="card-body">
                            <div class="row align-items-center">
                                <div class="col-6">
                                    <div class="text-center">
                                        <div class="h3 text-danger">¥{$stats.total_unpaid_amount|default=0}</div>
                                        <div class="text-muted">待支付</div>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="text-center">
                                        <div class="h3 text-success">¥{$stats.total_receivable_amount|default=0}</div>
                                        <div class="text-muted">应收款</div>
                                    </div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <div class="progress" style="height: 8px;">
                                    {if $stats.total_amount > 0}
                                        <div class="progress-bar bg-danger"
                                             style="width: {$stats.unpaid_percentage}%"></div>
                                        <div class="progress-bar bg-success"
                                             style="width: {$stats.receivable_percentage}%"></div>
                                    {/if}
                                </div>
                                <div class="row mt-2">
                                    <div class="col-6">
                                        <small class="text-muted">待支付比例</small>
                                    </div>
                                    <div class="col-6 text-end">
                                        <small class="text-muted">{$stats.unpaid_percentage|default=0}%</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">快速操作</h3>
                        </div>
                        <div class="card-body">
                            <div class="d-grid gap-2">
                                <a href="/user/payment" class="btn btn-outline-danger">
                                    <svg class="icon me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                                    </svg>
                                    查看需支付款项
                                </a>
                                <a href="/user/item" class="btn btn-outline-success">
                                    <svg class="icon me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                    </svg>
                                    查看我创建的收款
                                </a>
                                <a href="/user/invoice" class="btn btn-outline-primary">
                                    <svg class="icon me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M9 17v-2m3 2v-4m3 4v-6m2 10H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                    </svg>
                                    查看总未支付款项
                                </a>
                                {if app()->userService->getUser()->is_admin}
                                <a href="/admin" class="btn btn-outline-warning">
                                    <svg class="icon me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    </svg>
                                    管理界面
                                </a>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 最近加入的派对 -->
            {if $recentParties}
                <div class="row row-cards mt-3">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">最近加入的派对</h3>
                                <div class="card-actions">
                                    <a href="/user/party" class="btn btn-primary btn-sm">查看全部</a>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    {foreach $recentParties as $party}
                                        <div class="col-md-6 col-lg-4 mb-3">
                                            <div class="card card-sm">
                                                <div class="card-body">
                                                    <div class="d-flex align-items-center">
                                                <span class="avatar me-3 rounded bg-blue-lt">
                                                    <svg class="icon" fill="none" stroke="currentColor"
                                                         viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round"
                                                              stroke-width="2"
                                                              d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                                    </svg>
                                                </span>
                                                        <div class="flex-fill">
                                                            <div class="font-weight-medium">{$party.name}</div>
                                                            {if $party.description}
                                                                <div class="text-muted small">{$party.description}</div>
                                                            {/if}
                                                        </div>
                                                    </div>
                                                    <div class="mt-3">
                                                        <a href="/user/party/{$party.id}"
                                                           class="btn btn-outline-primary btn-sm w-100">查看详情</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            {/if}
            </div>
        </div>
    </div>
</div>

<style>
    /* 图片链接样式 */
    .page-header img {
        transition: transform 0.2s ease, filter 0.2s ease;
    }

    .page-header img:hover {
        transform: scale(1.1);
        filter: brightness(1.1);
    }

    .page-header a:hover {
        text-decoration: none;
    }
</style>

{include file="/footer"}
