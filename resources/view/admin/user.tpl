{include file="admin/header"}

<title>用户管理</title>
<div class="page">
    <div class="page-wrapper">
        <div class="page-header d-print-none">
            <div class="container-xl">
                <div class="row g-2 align-items-center">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">用户管理</h3>
                            <div class="card-subtitle">管理系统中的所有用户账户</div>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-striped table-nowrap">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>用户名</th>
                                        <th>管理员权限</th>
                                        <th>操作</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {if $users->isEmpty()}
                                        <tr>
                                            <td class="text-center" colspan="4">暂无数据</td>
                                        </tr>
                                    {/if}
                                    {volist name="users" id="user"}
                                        <tr>
                                            <td>{$user.id}</td>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <span class="avatar avatar-sm me-2 rounded bg-blue-lt">
                                                        <i class="fa-solid fa-user"></i>
                                                    </span>
                                                    <span class="font-weight-medium">{$user.username}</span>
                                                </div>
                                            </td>
                                            <td>
                                                {if $user.is_admin}
                                                    <span class="badge bg-success text-success-fg">管理员</span>
                                                {else}
                                                    <span class="badge bg-secondary text-secondary-fg">普通用户</span>
                                                {/if}
                                            </td>
                                            <td>
                                                <div class="btn-list">
                                                    <button class="btn btn-sm btn-outline-primary" 
                                                            onclick="changePassword({$user.id}, '{$user.username}')">
                                                        <i class="fa-solid fa-key me-1"></i>
                                                        修改密码
                                                    </button>
                                                    {if $user.is_admin}
                                                        <button class="btn btn-sm btn-outline-warning" 
                                                                onclick="toggleAdmin({$user.id}, '{$user.username}', false)">
                                                            <i class="fa-solid fa-user-minus me-1"></i>
                                                            取消管理员
                                                        </button>
                                                    {else}
                                                        <button class="btn btn-sm btn-outline-success" 
                                                                onclick="toggleAdmin({$user.id}, '{$user.username}', true)">
                                                            <i class="fa-solid fa-user-shield me-1"></i>
                                                            设为管理员
                                                        </button>
                                                    {/if}
                                                </div>
                                            </td>
                                        </tr>
                                    {/volist}
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// 修改密码弹窗
function changePassword(userId, username) {
    Swal.fire({
        title: '修改用户密码',
        html: `
            <div class="text-start">
                <div class="mb-3">
                    <label class="form-label">用户名</label>
                    <input type="text" class="form-control" id="swal-username" value="${username}" readonly>
                </div>
                <div class="mb-3">
                    <label class="form-label">新密码</label>
                    <input type="password" class="form-control" id="swal-new-password" placeholder="请输入新密码">
                </div>
                <div class="mb-3">
                    <label class="form-label">确认密码</label>
                    <input type="password" class="form-control" id="swal-confirm-password" placeholder="请再次输入新密码">
                </div>
            </div>
        `,
        showCancelButton: true,
        confirmButtonText: '确认修改',
        cancelButtonText: '取消',
        confirmButtonColor: '#206bc4',
        cancelButtonColor: '#6c757d',
        width: '500px',
        preConfirm: () => {
            const newPassword = document.getElementById('swal-new-password').value;
            const confirmPassword = document.getElementById('swal-confirm-password').value;
            
            // 验证密码
            if (!newPassword) {
                Swal.showValidationMessage('请输入新密码');
                return false;
            }
            
            if (newPassword !== confirmPassword) {
                Swal.showValidationMessage('两次输入的密码不一致');
                return false;
            }
            
            if (newPassword.length < 6) {
                Swal.showValidationMessage('密码长度至少6位');
                return false;
            }
            
            return {
                newPassword: newPassword
            };
        }
    }).then((result) => {
        if (result.isConfirmed) {
            submitChangePassword(userId, result.value.newPassword);
        }
    });
}

// 提交修改密码
function submitChangePassword(userId, newPassword) {
    // 显示加载状态
    Swal.fire({
        title: '正在修改密码...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
    
    // 发送请求
    fetch('/admin/user/change-password', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify({
            user_id: userId,
            new_password: newPassword
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.ret === 1) {
            Swal.fire({
                icon: 'success',
                title: '密码修改成功！',
                text: '用户密码已成功更新',
                confirmButtonColor: '#206bc4'
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: '密码修改失败',
                text: data.msg || '未知错误',
                confirmButtonColor: '#206bc4'
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Swal.fire({
            icon: 'error',
            title: '请求失败',
            text: '请检查网络连接后重试',
            confirmButtonColor: '#206bc4'
        });
    });
}

// 切换管理员权限
function toggleAdmin(userId, username, setAsAdmin) {
    const action = setAsAdmin ? '设为管理员' : '取消管理员权限';
    const actionText = setAsAdmin ? '设为管理员' : '取消管理员权限';
    
    Swal.fire({
        title: '确认操作',
        text: `确定要将用户 "${username}" ${actionText} 吗？`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonText: '确认',
        cancelButtonText: '取消',
        confirmButtonColor: setAsAdmin ? '#28a745' : '#ffc107',
        cancelButtonColor: '#6c757d'
    }).then((result) => {
        if (result.isConfirmed) {
            submitToggleAdmin(userId, username, setAsAdmin);
        }
    });
}

// 提交管理员权限切换
function submitToggleAdmin(userId, username, setAsAdmin) {
    // 显示加载状态
    Swal.fire({
        title: '正在更新权限...',
        allowOutsideClick: false,
        didOpen: () => {
            Swal.showLoading();
        }
    });
    
    // 发送请求
    fetch('/admin/user/toggle-admin', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify({
            user_id: userId,
            set_as_admin: setAsAdmin
        })
    })
    .then(response => response.json())
    .then(data => {
        if (data.ret === 1) {
            Swal.fire({
                icon: 'success',
                title: '权限更新成功！',
                text: `用户 "${username}" 的权限已成功更新`,
                confirmButtonColor: '#206bc4'
            }).then(() => {
                // 刷新页面以显示更新后的状态
                location.reload();
            });
        } else {
            Swal.fire({
                icon: 'error',
                title: '权限更新失败',
                text: data.msg || '未知错误',
                confirmButtonColor: '#206bc4'
            });
        }
    })
    .catch(error => {
        console.error('Error:', error);
        Swal.fire({
            icon: 'error',
            title: '请求失败',
            text: '请检查网络连接后重试',
            confirmButtonColor: '#206bc4'
        });
    });
}

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    // 可以在这里添加其他初始化代码
});
</script>

{include file="/footer"}