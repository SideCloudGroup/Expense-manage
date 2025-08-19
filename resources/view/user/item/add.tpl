{include file="/user/header"}
<title>{:getSetting('general_name')} - 添加项目</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">添加收款项</h2>
                        <div class="text-muted mt-1">在选定的派对中添加新的收款项</div>
                    </div>
                </div>
            </div>

            <div class="row row-cards">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">收款项信息</h3>
                        </div>
                        <div class="card-body">
                            <form hx-post="/user/item/add" hx-trigger="submit" hx-swap="none">
                                <!-- 第一步：选择派对 -->
                                <div id="step1" class="mb-4">
                                    <h4 class="mb-3">第一步：选择派对</h4>
                                    <div class="mb-3">
                                        <label class="form-label required">选择派对</label>
                                        <div class="form-selectgroup">
                                            {volist name="parties" id="party"}
                                                <label class="form-selectgroup-item">
                                                    <input type="radio" name="party_id" value="{$party.id}"
                                                           class="form-selectgroup-input" required
                                                           onchange="onPartySelected({$party.id})">
                                                    <span class="form-selectgroup-label">
                                        <div class="font-weight-medium">{$party.name}</div>
                                    </span>
                                                </label>
                                            {/volist}
                                        </div>
                                        {if empty($parties)}
                                            <div class="alert alert-warning mt-2">
                                                您还没有加入任何派对，请先
                                                <a href="/user/party/create" class="alert-link">创建派对</a>
                                                或
                                                <a href="/user/party/join" class="alert-link">加入派对</a>
                                            </div>
                                        {/if}
                                    </div>
                                </div>

                                <!-- 第二步：选择用户（初始隐藏） -->
                                <div id="step2" class="mb-4" style="display: none;">
                                    <h4 class="mb-3">第二步：选择用户</h4>
                                    <div class="mb-3">
                                        <label class="form-label">选择用户</label>
                                        <div class="mb-2">
                                            <span class="text-muted">已选人数：</span>
                                            <span id="selectedUserCount"
                                                  class="badge bg-primary text-primary-fg fs-6">0</span>
                                        </div>
                                        <div id="userSelection" class="form-selectgroup">
                                            <!-- 用户选择框将通过AJAX动态加载 -->
                                        </div>
                                    </div>
                                </div>

                                <!-- 第三步：填写收款项详情（初始隐藏） -->
                                <div id="step3" class="mb-4" style="display: none;">
                                    <h4 class="mb-3">第三步：填写收款项详情</h4>

                                    <div class="mb-3">
                                        <label class="form-label required">收款项名称</label>
                                        <input autocomplete="off" class="form-control" id="description"
                                               name="description" type="text"
                                               placeholder="例如：午餐费用、交通费等" required>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">人均金额</label>
                                                <input autocomplete="off" class="form-control" id="amount" name="amount"
                                                       type="number"
                                                       step="0.01" placeholder="0.00" required>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label class="form-label">或总金额</label>
                                                <input autocomplete="off" class="form-control" id="totalamount"
                                                       name="totalamount"
                                                       type="number"
                                                       step="0.01" placeholder="0.00">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label required">货币单位</label>
                                        <select class="form-select" id="unit" name="unit" required>
                                            {volist name="currencies" id="currency"}
                                                <option value="{$key}">{$key}</option>
                                            {/volist}
                                        </select>
                                    </div>

                                    <!-- 隐藏字段 -->
                                    <input type="hidden" id="party_id" name="party_id" required>
                                    <input type="hidden" id="users" name="users" required>

                                    <div class="form-footer">
                                        <button class="btn btn-primary btn-save" type="submit">
                                            保存收款项
                                        </button>
                                    </div>
                                </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">操作步骤</h3>
                        </div>
                        <div class="card-body">
                            <div class="row g-3">
                                <div class="col-12">
                                    <div class="d-flex align-items-center p-3 bg-primary-lt rounded">
                                        <div class="flex-shrink-0">
                                    <span class="avatar bg-primary text-primary-fg rounded-circle">
                                        <span class="avatar-text">1</span>
                                    </span>
                                        </div>
                                        <div class="flex-fill ms-3">
                                            <div class="font-weight-medium">选择派对</div>
                                            <div class="text-muted small">选择要添加收款项的派对</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="d-flex align-items-center p-3 bg-success-lt rounded">
                                        <div class="flex-shrink-0">
                                    <span class="avatar bg-success text-success-fg rounded-circle">
                                        <span class="avatar-text">2</span>
                                    </span>
                                        </div>
                                        <div class="flex-fill ms-3">
                                            <div class="font-weight-medium">选择用户</div>
                                            <div class="text-muted small">选择需要分摊费用的用户</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="d-flex align-items-center p-3 bg-warning-lt rounded">
                                        <div class="flex-shrink-0">
                                    <span class="avatar bg-warning text-warning-fg rounded-circle">
                                        <span class="avatar-text">3</span>
                                    </span>
                                        </div>
                                        <div class="flex-fill ms-3">
                                            <div class="font-weight-medium">填写详情</div>
                                            <div class="text-muted small">填写收款项的详细信息</div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="mt-4 p-3 bg-light rounded">
                                <div class="d-flex align-items-center">
                                    <svg class="icon text-info me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                    </svg>
                                    <div class="text-muted small">
                                        <strong>提示：</strong>每个步骤完成后，下一步会自动显示
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let selectedPartyId = null;
    let allUsers = [];

    // 派对选择事件
    function onPartySelected(partyId) {
        selectedPartyId = partyId;

        // 更新隐藏字段
        document.getElementById('party_id').value = partyId;

        // 显示第二步
        document.getElementById('step2').style.display = 'block';

        // 加载该派对的用户列表
        loadPartyUsers(partyId);
    }

    // 加载派对成员列表
    function loadPartyUsers(partyId) {
        fetch(`/user/party/${partyId}/users`)
            .then(response => response.json())
            .then(data => {
                if (data.ret === 1) {
                    allUsers = data.users;
                    renderUserSelection();
                } else {
                    Swal.fire('错误', '获取派对成员失败', 'error');
                }
            })
            .catch(error => {
                Swal.fire('错误', '获取派对成员失败', 'error');
            });
    }

    // 渲染用户选择框
    function renderUserSelection() {
        const container = document.getElementById('userSelection');
        container.innerHTML = '';

        allUsers.forEach(user => {
            const label = document.createElement('label');
            label.className = 'form-selectgroup-item';
            label.innerHTML = `
            <input type="checkbox" name="users[]" value="${user.id}" 
                   class="form-selectgroup-input" onchange="updateAmount()">
            <span class="form-selectgroup-label">${user.username}</span>
        `;
            container.appendChild(label);
        });

        // 显示第三步
        document.getElementById('step3').style.display = 'block';
    }

    // 更新金额计算
    function updateAmount() {
        var totalAmountInput = document.getElementById('totalamount');
        var amountInput = document.getElementById('amount');
        var totalAmount = parseFloat(totalAmountInput.value);
        var selectedUsers = getSelectedUsers();
        var userCount = selectedUsers.length;

        if (userCount > 0 && totalAmount > 0) {
            var amount = totalAmount / userCount;
            amountInput.value = amount.toFixed(2);
        }

        updateSelectedUserCount(userCount);

        // 更新隐藏字段
        document.getElementById('users').value = JSON.stringify(selectedUsers);
    }

    // 获取选中的用户
    function getSelectedUsers() {
        var users = [];
        var checkboxes = document.querySelectorAll('input[name="users[]"]');
        checkboxes.forEach(function (checkbox) {
            if (checkbox.checked) {
                users.push(checkbox.value);
            }
        });
        return users;
    }

    // 更新已选用户数量
    function updateSelectedUserCount(count) {
        var userCountElement = document.getElementById('selectedUserCount');
        userCountElement.textContent = count;
    }

    // 更新隐藏字段
    function updateHiddenFields() {
        if (selectedPartyId) {
            document.getElementById('party_id').value = selectedPartyId;
        }

        var selectedUsers = getSelectedUsers();
        if (selectedUsers.length > 0) {
            document.getElementById('users').value = JSON.stringify(selectedUsers);
        }
    }

    // 事件监听器
    document.getElementById('totalamount').addEventListener('input', updateAmount);

    // 初始化
    document.addEventListener('DOMContentLoaded', function () {
        // 如果没有派对，隐藏后续步骤
        if (document.querySelectorAll('input[name="party_id"]').length === 0) {
            document.getElementById('step2').style.display = 'none';
            document.getElementById('step3').style.display = 'none';
        }
    });
</script>

{include file="/footer"}
