{include file="/user/header"}
<title>{:env('APP_NAME')} - 创建派对</title>

<div class="page">
    <div class="page-wrapper">
        <div class="container-xl">
            <div class="page-header d-print-none">
                <div class="row align-items-center">
                    <div class="col">
                        <h2 class="page-title">创建派对</h2>
                        <div class="text-muted mt-1">创建一个新的派对，邀请朋友一起记账</div>
                    </div>
                </div>
            </div>

            <div class="row row-cards">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">派对信息</h3>
                        </div>
                        <div class="card-body">
                            <form id="createPartyForm" hx-post="/user/party" hx-target="body">
                                <div class="mb-3">
                                    <label class="form-label required">派对名称</label>
                                    <input type="text" class="form-control" name="name" required
                                           placeholder="例如：周末聚餐、旅行费用等">
                                    <div class="form-hint">给您的派对起一个容易识别的名称</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">描述（可选）</label>
                                    <textarea class="form-control" name="description" rows="4"
                                              placeholder="描述这个派对的用途或规则..."></textarea>
                                    <div class="form-hint">可以描述派对的用途、规则或其他相关信息</div>
                                </div>

                                <div class="form-footer">
                                    <a href="/user/party" class="btn btn-secondary">取消</a>
                                    <button type="submit" class="btn btn-primary">创建派对</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h3 class="card-title">创建派对后您可以：</h3>
                        </div>
                        <div class="card-body">
                            <ul class="list-unstyled space-y">
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    获得唯一的邀请码，分享给朋友
                                </li>
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    在派对内添加和管理账目
                                </li>
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    查看派对成员的收支情况
                                </li>
                                <li class="d-flex">
                                    <svg class="icon text-green me-2" fill="none" stroke="currentColor"
                                         viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                              d="M5 13l4 4L19 7"/>
                                    </svg>
                                    生成最优支付方案
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

{include file="/footer"}
