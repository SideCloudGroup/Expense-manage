{include file="admin/header"}

<title>派对成员 - 管理后台</title>

<div class="page">
    <div class="page-wrapper">
        <div class="page-body">
            <div class="container-xl">
                <!-- 页面标题 -->
                <div class="page-header d-print-none">
                    <div class="row align-items-center">
                        <div class="col">
                            <h2 class="page-title">{$party.name} - 成员列表</h2>
                            <div class="text-muted mt-1">查看派对成员和详细信息</div>
                        </div>
                        <div class="col-auto ms-auto d-print-none">
                            <div class="btn-list">
                                <a href="/admin/party" class="btn btn-secondary">
                                    <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                    </svg>
                                    返回派对列表
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 派对信息卡片 -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">派对信息</h3>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6">
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
                                                创建时间: {:date('Y-m-d H:i', strtotime($party.created_at))}
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
                                    <div class="col-md-6">
                                        <div class="text-end">
                                            <span class="badge bg-success text-success-fg fs-6">
                                                {:count($members)} 人
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 统计信息 -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body text-center">
                                <div class="h2 mb-1 text-primary">{$stats.total_items}</div>
                                <div class="text-muted">总项目</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body text-center">
                                <div class="h2 mb-1 text-success">{$stats.paid_items}</div>
                                <div class="text-muted">已支付</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body text-center">
                                <div class="h2 mb-1 text-warning">{$stats.unpaid_items}</div>
                                <div class="text-muted">未支付</div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card">
                            <div class="card-body text-center">
                                <div class="h2 mb-1 text-info">{$currencySymbol} {$stats.total_amount}</div>
                                <div class="text-muted">总金额</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 支付进度 -->
                {if $stats.total_items > 0}
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <span class="text-muted">支付完成率</span>
                                        <span class="text-muted">{$stats.payment_completion_rate}%</span>
                                    </div>
                                    <div class="progress" style="height: 8px;">
                                        <div class="progress-bar bg-success"
                                             style="width: {$stats.payment_completion_rate}%"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}

                <!-- 成员列表 -->
                <div class="row">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h3 class="card-title">成员列表</h3>
                            </div>
                            <div class="card-body">
                                {if empty($members)}
                                    <div class="empty">
                                        <div class="empty-img">
                                            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                            </svg>
                                        </div>
                                        <p class="empty-title">暂无成员</p>
                                        <p class="empty-subtitle text-muted">
                                            该派对还没有任何成员加入。
                                        </p>
                                    </div>
                                {else}
                                    <div class="table-responsive">
                                        <table class="table table-vcenter">
                                            <thead>
                                            <tr>
                                                <th>用户</th>
                                                <th>角色</th>
                                                <th>加入时间</th>
                                            </tr>
                                            </thead>
                                            <tbody>
                                            {volist name="members" id="member"}
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div>
                                                                <div class="font-weight-medium">{$member.username}</div>
                                                                <div class="text-muted">ID: {$member.id}</div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                    <td>
                                                        {if $member.is_owner}
                                                            <span class="badge bg-success text-success-fg">派对所有者</span>
                                                        {else}
                                                            <span class="badge bg-secondary text-secondary-fg">成员</span>
                                                        {/if}
                                                    </td>
                                                    <td>
                                                        <div class="text-muted">
                                                            {:date('Y-m-d H:i', strtotime($member.joined_at))}
                                                        </div>
                                                    </td>
                                                </tr>
                                            {/volist}
                                            </tbody>
                                        </table>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}
