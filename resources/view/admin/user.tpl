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

                        </div>
                        <div class="card-body">
                            <div class="mb-2">
                                <label class="form-label">用户名</label>
                                <input id="username" type="text" class="form-control">
                            </div>
                            <div class="mb-2">
                                <label class="form-label">密码</label>
                                <input id="password" type="password" class="form-control">
                            </div>
                            <div class="form-footer">
                                <button class="btn btn-primary w-100"
                                        hx-post="/admin/user" hx-swap="none" hx-vals='js:{
                                        username: document.getElementById("username").value,
                                        password: document.getElementById("password").value
                                        }'>
                                    添加用户
                                </button>
                                <hr>
                                <table class="table table-striped table-nowrap">
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>用户名</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {if $users->isEmpty()}
                                        <tr>
                                            <td class="text-center" colspan="2">暂无数据</td>
                                        </tr>
                                    {/if}
                                    {volist name="users" id="user"}
                                        <tr>
                                            <td>{$user.id}</td>
                                            <td>{$user.username}</td>
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

{include file="/footer"}