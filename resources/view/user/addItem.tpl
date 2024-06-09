{include file="/user/header"}
<title>添加项目</title>
<div class="container" style="margin-top: 2%; width: auto;">
    <div class="card" style="margin-top: 26px">
        <div class="card border">
            <h2 class="card-header bg-primary text-white text-center">添加收款项</h2>
            <div class="card-body">
                <div class="row">
                    <div class="mb-3">
                        <label class="form-label">选择用户</label>
                        <div class="mb-2">已选人数:
                            <span id="selectedUserCount">0</span>
                        </div>
                        <div class="form-selectgroup">
                            {volist name="users" id="user"}
                                <label class="form-selectgroup-item">
                                    <input type="checkbox" name="users[]" value="{$user.id}"
                                           class="form-selectgroup-input">
                                    <span class="form-selectgroup-label">{$user.username}</span>
                                </label>
                            {/volist}
                        </div>
                    </div>
                    <hr>
                    <div class="col-sm-12 col-lg-12">
                        <div class="input-group mb-3">
                            <span class="input-group-text">名称</span>
                            <input autocomplete="off" class="form-control" id="description" type="text">
                        </div>
                    </div>
                    <hr>
                    <div class="col-sm-12 col-lg-5">
                        <div class="input-group mb-3">
                            <span class="input-group-text">人均金额</span>
                            <input autocomplete="off" class="form-control" id="amount" type="number">
                        </div>
                    </div>
                    <div class="col-sm-12 col-lg-2 text-center">
                        <span>--OR--</span>
                    </div>
                    <div class="col-sm-12 col-lg-5">
                        <div class="input-group mb-3">
                            <span class="input-group-text">总金额</span>
                            <input autocomplete="off" class="form-control" id="totalamount" type="number">
                        </div>
                    </div>
                    <button class="btn btn-primary btn-block btn-save"
                            type="submit"
                            hx-post="/user/item/add"
                            hx-trigger="click"
                            hx-swap="none"
                            hx-disabled-elt="button"
                            hx-vals='js:{
                                "description": document.getElementById("description").value,
                                "amount": document.getElementById("amount").value,
                                "users": JSON.stringify(getSelectedUsers())
                            }'>
                        保存
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    function updateAmount() {
        var totalAmountInput = document.getElementById('totalamount');
        var amountInput = document.getElementById('amount');
        var totalAmount = parseFloat(totalAmountInput.value);
        var selectedUsers = getSelectedUsers();
        var userCount = selectedUsers.length;
        if (userCount > 0) {
            var amount = totalAmount / userCount;
            amountInput.value = amount.toFixed(2);
        } else {
            amountInput.value = '';
        }
        updateSelectedUserCount(userCount); // 更新已选用户数量
    }

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

    function updateSelectedUserCount(count) {
        var userCountElement = document.getElementById('selectedUserCount');
        userCountElement.textContent = count;
    }

    document.getElementById('totalamount').addEventListener('input', updateAmount);

    document.querySelectorAll('input[name="users[]"]').forEach(function (checkbox) {
        checkbox.addEventListener('change', updateAmount);
    });

</script>
{include file="/footer"}
