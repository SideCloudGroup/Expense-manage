{include file="/user/header"}
<title>{:getSetting('general_name')} - 我创建的收款</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">我创建的收款</h2>
                        <div class="text-muted mt-1">选择派对查看您创建的收款项目</div>
                    </div>
                </div>
            </div>

            <div class="row row-cards">
                {if $parties}
                    {foreach $parties as $party}
                        <div class="col-md-6 col-lg-4">
                            <div class="card card-sm">
                                <div class="card-body">
                                    <div class="d-flex align-items-center">
                                        <span class="avatar me-3 rounded bg-green-lt">
                                            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                            </svg>
                                        </span>
                                        <div class="flex-fill">
                                            <div class="font-weight-medium">{$party.name}</div>
                                            {if $party.description}
                                                <div class="text-muted">{$party.description}</div>
                                            {/if}
                                            <div class="mt-2">
                                                <span class="badge bg-warning text-warning-fg">
                                                    未收款: ¥{$party.total_amount|default=0}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="mt-3">
                                        <a href="/user/item/party/{$party.id}" class="btn btn-success w-100">
                                            查看详情
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                {else}
                    <div class="col-12">
                        <div class="card card-body text-center">
                            <div class="empty">
                                <div class="empty-img">
                                    <svg class="icon icon-3xl" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                    </svg>
                                </div>
                                <p class="empty-title">还没有加入派对</p>
                                <p class="empty-subtitle text-muted">加入派对后才能创建收款项目</p>
                                <div class="empty-action">
                                    <a href="/user/party" class="btn btn-primary">
                                        <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M17 20h5v-2a3 3 0 11-6 0 3 3 0 016 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                        </svg>
                                        查看我的派对
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}
            </div>
        </div>
    </div>
</div>

{include file="/footer"}