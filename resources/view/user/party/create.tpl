{include file="/user/header"}
<title>{:getSetting('general_name')} - 创建派对</title>

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
                            <form id="createPartyForm" hx-post="/user/party" hx-target="body" hx-swap="none">
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

                                <div class="mb-3">
                                    <label class="form-label required">时区设置</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="timezone-input" name="timezone"
                                               value="Asia/Shanghai" required
                                               placeholder="输入时区标识符，如：Asia/Shanghai、Europe/London"
                                               oninput="searchTimezones()" onchange="validateTimezone()">
                                        <button class="btn btn-outline-secondary" type="button"
                                                onclick="showTimezoneHelp()">
                                            <svg class="icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                      d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                            </svg>
                                            帮助
                                        </button>
                                    </div>
                                    <div class="form-hint">
                                        <span id="timezone-hint">输入时区标识符，系统将自动验证并显示当前偏移量</span>
                                        <br>
                                        <small class="text-muted">格式：Continent/City（如：Asia/Shanghai、Europe/London、America/New_York）</small>
                                    </div>

                                    <!-- 时区搜索结果 -->
                                    <div id="timezone-results" class="mt-2" style="display: none;">
                                        <div class="list-group list-group-flush">
                                            <!-- 搜索结果将在这里动态显示 -->
                                        </div>
                                    </div>
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

<script>
    // 时区搜索防抖定时器
    let searchTimeout = null;
    // 时区验证防抖定时器
    let validateTimeout = null;

    // 时区搜索功能
    function searchTimezones() {
        const input = document.getElementById('timezone-input');
        const resultsDiv = document.getElementById('timezone-results');
        const query = input.value.trim();

        if (query.length < 2) {
            resultsDiv.style.display = 'none';
            return;
        }

        // 清除之前的定时器
        if (searchTimeout) {
            clearTimeout(searchTimeout);
        }

        // 设置500ms延迟，等待用户输入完成
        searchTimeout = setTimeout(() => {
            // 使用API搜索时区
            fetch(`/user/party/search-timezones?query=${encodeURIComponent(query)}`)
                .then(response => response.json())
                .then(data => {
                    if (data.ret === 1 && data.timezones.length > 0) {
                        displayTimezoneResults(data.timezones);
                    } else {
                        resultsDiv.style.display = 'none';
                    }
                })
                .catch(error => {
                    console.error('搜索时区失败:', error);
                    resultsDiv.style.display = 'none';
                });
        }, 500); // 500ms延迟
    }

    // 显示时区搜索结果
    function displayTimezoneResults(timezones) {
        const resultsDiv = document.getElementById('timezone-results');
        const listGroup = resultsDiv.querySelector('.list-group');

        listGroup.innerHTML = '';

        timezones.forEach(timezone => {
            const item = document.createElement('div');
            item.className = 'list-group-item list-group-item-action';
            item.style.cursor = 'pointer';
            item.textContent = timezone;
            item.onclick = () => selectTimezone(timezone);
            listGroup.appendChild(item);
        });

        resultsDiv.style.display = 'block';
    }

    // 选择时区
    function selectTimezone(timezone) {
        const input = document.getElementById('timezone-input');
        const resultsDiv = document.getElementById('timezone-results');

        input.value = timezone;
        resultsDiv.style.display = 'none';
        validateTimezone();
    }

    // 验证时区
    function validateTimezone() {
        const input = document.getElementById('timezone-input');
        const hint = document.getElementById('timezone-hint');
        const timezone = input.value.trim();

        if (!timezone) {
            hint.textContent = '时区不能为空';
            hint.className = 'text-danger';
            return false;
        }

        // 清除之前的验证定时器
        if (validateTimeout) {
            clearTimeout(validateTimeout);
        }

        // 设置300ms延迟，等待用户输入完成
        validateTimeout = setTimeout(() => {
            // 使用API验证时区
            fetch('/user/party/validate-timezone', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `timezone=${encodeURIComponent(timezone)}`
            })
                .then(response => response.json())
                .then(data => {
                    if (data.ret === 1) {
                        const offset = data.current_offset;
                        const dst = data.is_dst ? ' (夏令时)' : '';
                        hint.textContent = `时区有效 - 当前偏移：${offset}${dst}`;
                        hint.className = 'text-success';
                    } else {
                        hint.textContent = data.msg || '无效的时区标识符';
                        hint.className = 'text-danger';
                    }
                })
                .catch(error => {
                    console.error('验证时区失败:', error);
                    hint.textContent = '验证失败，请重试';
                    hint.className = 'text-warning';
                });
        }, 300); // 300ms延迟

        return true; // 允许继续，因为验证是异步的
    }

    // 显示时区帮助信息
    function showTimezoneHelp() {
        Swal.fire({
            title: '时区输入帮助',
            html: `
            <div class="text-start">
                <h6>时区格式说明：</h6>
                <p>时区标识符格式为：<code>Continent/City</code></p>
                
                <h6>常用时区示例：</h6>
                <ul class="text-start">
                    <li><strong>亚洲：</strong>Asia/Shanghai, Asia/Tokyo, Asia/Singapore</li>
                    <li><strong>欧洲：</strong>Europe/London, Europe/Paris, Europe/Berlin</li>
                    <li><strong>美洲：</strong>America/New_York, America/Los_Angeles</li>
                    <li><strong>大洋洲：</strong>Australia/Sydney, Pacific/Auckland</li>
                </ul>
                
                <h6>注意事项：</h6>
                <ul class="text-start">
                    <li>系统会自动处理夏令时/冬令时</li>
                    <li>时区名称区分大小写</li>
                    <li>城市名中的空格用下划线替代</li>
                </ul>
            </div>
        `,
            icon: 'info',
            confirmButtonColor: '#206bc4',
            width: '600px'
        });
    }

    // 表单提交前验证
    document.getElementById('createPartyForm').addEventListener('submit', function (e) {
        if (!validateTimezone()) {
            e.preventDefault();
            Swal.fire({
                icon: 'warning',
                title: '时区验证失败',
                text: '请输入有效的时区标识符',
                confirmButtonColor: '#206bc4'
            });
            return false;
        }
    });

    // 页面加载完成后初始化
    document.addEventListener('DOMContentLoaded', function () {
        // 隐藏搜索结果
        document.getElementById('timezone-results').style.display = 'none';

        // 点击其他地方时隐藏搜索结果
        document.addEventListener('click', function (e) {
            const resultsDiv = document.getElementById('timezone-results');
            const input = document.getElementById('timezone-input');

            if (!resultsDiv.contains(e.target) && e.target !== input) {
                resultsDiv.style.display = 'none';
            }
        });

        // 页面卸载时清理定时器
        window.addEventListener('beforeunload', function () {
            if (searchTimeout) {
                clearTimeout(searchTimeout);
            }
            if (validateTimeout) {
                clearTimeout(validateTimeout);
            }
        });
    });
</script>

{include file="/footer"}
