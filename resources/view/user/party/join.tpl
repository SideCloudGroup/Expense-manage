{include file="/user/header"}
<title>{:env('APP_NAME')} - 加入派对</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">加入派对</h2>
                        <div class="text-muted mt-1">输入朋友分享的邀请码来加入派对</div>
                    </div>
                </div>
            </div>

            <div class="row row-cards">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">输入邀请码</h3>
                        </div>
                        <div class="card-body">
                            <form id="joinPartyForm" hx-post="/user/party/join" hx-swap="none">
                                <div class="mb-3">
                                    <label class="form-label required">邀请码</label>
                                    <input type="text" class="form-control text-center" name="invite_code" required
                                           placeholder="例如：A1B2C3D4" maxlength="8"
                                           style="font-size: 1.2rem; letter-spacing: 0.2em;">
                                    <div class="form-hint">邀请码通常是由8位字母和数字组成的</div>
                                </div>

                                <div class="form-footer">
                                    <a href="/user/party" class="btn btn-secondary">取消</a>
                                    <button type="submit" class="btn btn-success">加入派对</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">加入派对后您可以：</h3>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled space-y">
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    查看派对内的所有账目
                                </li>
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    添加新的收款项
                                </li>
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    查看自己的收支情况
                                </li>
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    与其他成员一起分摊费用
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="card mt-3">
                        <div class="card-body text-center">
                            <p class="text-muted mb-2">还没有邀请码？</p>
                            <a href="/user/party/create" class="btn btn-primary">
                                <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                          d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                                </svg>
                                创建一个新的派对
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}
