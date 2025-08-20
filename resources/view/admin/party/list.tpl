{include file="admin/header"}

<title>派对管理 - 管理后台</title>

<div class="page">
    <div class="page-wrapper">
        <div class="page-body">
            <div class="container-xl">
                <!-- 页面标题 -->
                <div class="page-header d-print-none">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">派对管理</h2>
                            <div class="text-muted mt-1">管理系统中的所有派对，查看成员和支付统计</div>
                        </div>
                    </div>
                </div>

                <!-- 派对列表 -->
                <div class="row row-cards">
                    {volist name="parties" id="party"}
                        <div class="col-lg-6 col-xl-4">
                            <div class="card">
                                <div class="card-header">
                                    <h3 class="card-title">{$party.name}</h3>
                                    <div class="card-actions">
                                    <span class="badge bg-success text-success-fg">
                                        {$party.member_count} 人
                                    </span>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <!-- 派对信息 -->
                                    <div class="mb-3">
                                        {if $party.description}
                                            <p class="text-muted mb-2">{$party.description}</p>
                                        {/if}
                                        <div class="row text-muted small">
                                            <div class="col-6">
                                                <svg class="icon me-1" fill="none" stroke="currentColor"
                                                     viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                          stroke-width="2"
                                                          d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                                </svg>
                                                创建时间: {:date('Y-m-d', strtotime($party.created_at))}
                                            </div>
                                            <div class="col-6">
                                                <svg class="icon me-1" fill="none" stroke="currentColor"
                                                     viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                          stroke-width="2"
                                                          d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                                </svg>
                                                时区: {$party.timezone}
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 支付统计 -->
                                    <div class="row g-3 mb-3">
                                        <div class="col-6">
                                            <div class="text-center p-2 bg-light rounded">
                                                <div class="h4 mb-1 text-primary">{$party.total_items}</div>
                                                <div class="text-muted small">总项目</div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-center p-2 bg-light rounded">
                                                <div class="h4 mb-1 text-success">{$party.paid_items}</div>
                                                <div class="text-muted small">已支付</div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-center p-2 bg-light rounded">
                                                <div class="h4 mb-1 text-warning">{$party.unpaid_items}</div>
                                                <div class="text-muted small">未支付</div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="text-center p-2 bg-light rounded">
                                                <div class="h4 mb-1 text-info">{$party.currency_symbol} {$party.total_amount}</div>
                                                <div class="text-muted small">总金额</div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- 支付进度 -->
                                    {if $party.total_items > 0}
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between align-items-center mb-1">
                                                <span class="text-muted small">支付完成率</span>
                                                <span class="text-muted small">{$party.payment_completion_rate}%</span>
                                            </div>
                                            <div class="progress" style="height: 6px;">
                                                <div class="progress-bar bg-success"
                                                     style="width: {$party.payment_completion_rate}%"></div>
                                            </div>
                                        </div>
                                    {/if}

                                    <!-- 操作按钮 -->
                                    <div class="d-flex gap-2">
                                        <a href="/admin/party/{$party.id}/members"
                                           class="btn btn-outline-primary btn-sm flex-fill">
                                            <svg class="icon me-1" fill="none" stroke="currentColor"
                                                 viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                            </svg>
                                            查看详情
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/volist}
                </div>

                <!-- 空状态 -->
                {if empty($parties)}
                    <div class="empty">
                        <div class="empty-img">
                            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                      d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                        </div>
                        <p class="empty-title">暂无派对</p>
                        <p class="empty-subtitle text-muted">
                            系统中还没有创建任何派对，用户创建派对后会在这里显示。
                        </p>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>


{include file="/footer"}
