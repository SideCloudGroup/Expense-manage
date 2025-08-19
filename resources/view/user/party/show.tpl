{include file="/user/header"}
<title>{:getSetting('general_name')} - {$party.name}</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">{$party.name}</h2>
                        <div class="text-muted mt-1">
                            {if $party.description}{$party.description}{else}派对详情{/if}
                        </div>
                    </div>
                    <div class="col-auto ms-auto d-print-none">
                        <div class="btn-list">
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
                                          d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                                </svg>
                                返回列表
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row row-cards">
                <!-- 派对信息 -->
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">派对信息</h3>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">邀请码</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" value="{$party.invite_code}" readonly>
                                    <button class="btn btn-outline-secondary" type="button"
                                            onclick="copyInviteCode('{$party.invite_code}')">
                                        <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"/>
                                        </svg>
                                        复制
                                    </button>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">所有者</label>
                                <div class="form-control-plaintext">{$party.owner.username}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">时区设置</label>
                                <div class="form-control-plaintext">{:formatTimezone($party.timezone)}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">创建时间</label>
                                <div class="form-control-plaintext">{$party.created_at}</div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">成员数量</label>
                                <div class="form-control-plaintext">{:count($members)} 人</div>
                            </div>
                        </div>
                    </div>

                    <!-- 成员列表 -->
                    <div class="card mt-3">
                        <div class="card-header">
                            <h3 class="card-title">成员列表</h3>
                        </div>
                        <div class="card-body">
                            <div class="list-group list-group-flush">
                                {foreach $members as $member}
                                    <div class="list-group-item">
                                        <div class="row align-items-center">
                                            <div class="col-auto">
                                            <span class="avatar rounded">
                                                {:strtoupper(substr($member.username, 0, 1))}
                                            </span>
                                            </div>
                                            <div class="col">
                                                <div class="font-weight-medium">{$member.username}</div>
                                                <div class="text-muted">加入时间：{$member.joined_at}</div>
                                            </div>
                                            {if $party.owner_id == $member.id}
                                                <div class="col-auto">
                                                    <span class="badge bg-primary text-primary-fg">所有者</span>
                                                </div>
                                            {/if}
                                        </div>
                                    </div>
                                {/foreach}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 账目列表 -->
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">收款项列表</h3>
                        </div>
                        <div class="card-body">
                            {if $items}
                                <div class="table-responsive">
                                    <table class="table table-vcenter">
                                        <thead>
                                        <tr>
                                            <th>描述</th>
                                            <th>金额</th>
                                            <th>付款人</th>
                                            <th>发起人</th>
                                            <th>状态</th>
                                            <th>创建时间</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        {foreach $items as $item}
                                            <tr>
                                                <td>{$item.description}</td>
                                                <td>{$item.amount}</td>
                                                <td>{$item.payer_name}</td>
                                                <td>{$item.initiator_name}</td>
                                                <td>
                                                    {if $item.paid}
                                                        <span class="badge bg-success text-success-fg">已支付</span>
                                                    {else}
                                                        <span class="badge bg-warning text-warning-fg">未支付</span>
                                                    {/if}
                                                </td>
                                                <td>{$item.created_at}</td>
                                            </tr>
                                        {/foreach}
                                        </tbody>
                                    </table>
                                </div>
                            {else}
                                <div class="empty">
                                    <div class="empty-img">
                                        <svg class="icon icon-3xl" fill="none" stroke="currentColor"
                                             viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                                        </svg>
                                    </div>
                                    <p class="empty-title">还没有收款项</p>
                                    <p class="empty-subtitle text-muted">添加第一个收款项来开始记账吧！</p>
                                    <div class="empty-action">
                                        <a href="/user/item/add" class="btn btn-primary">
                                            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                                            </svg>
                                            添加收款项
                                        </a>
                                    </div>
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function copyInviteCode(code) {
        navigator.clipboard.writeText(code).then(function () {
            Swal.fire({
                title: '复制成功',
                text: '邀请码已复制到剪贴板',
                icon: 'success',
                timer: 1500,
                showConfirmButton: false
            });
        }).catch(function () {
            // 如果剪贴板API不可用，使用传统方法
            const textArea = document.createElement('textarea');
            textArea.value = code;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);

            Swal.fire({
                title: '复制成功',
                text: '邀请码已复制到剪贴板',
                icon: 'success',
                timer: 1500,
                showConfirmButton: false
            });
        });
    }
</script>

{include file="/footer"}
