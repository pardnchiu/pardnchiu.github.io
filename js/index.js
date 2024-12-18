let page;

const default_events = {
    show: function () {
        const isShow = this.$parent(0).$$class("show");
        this.__class(`fa-solid ${isShow ? "fa-eye-slash" : "fa-eye"}`);
        this.$pre(0).$child(0).type = isShow ? "password" : "text";
        this.$parent(0).$$class_(isShow, "show");
    },
    login: function () {
        page.dom.$child(0)._class("show");

        setTimeout(() => {
            page.data.is_guest = false;
        }, 1000);
    },
    logout: function () {
        page.data.is_guest = true;
    },
    body_left_show: function (e) {
        const dom_target = document.querySelector("section.body-left");

        if (dom_target == null) {
            return;
        };
        
        dom_target.dataset.show = parseInt(dom_target.dataset.show) ? 0 : 1;
    },
    body_left_type: function (e) {
        const dom_target = document.querySelector("section.body-left");

        if (dom_target == null) {
            return;
        };

        const is_min = parseInt(dom_target.dataset.min);
        dom_target.dataset.min = is_min ? 0 : 1;
        addCookie("is_body_left_min", is_min ? 0 : 1)
    },
    tab_show: function (e) {
        const dom_this = e.target;
        const dom_parent = dom_this.parentElement;
        const is_show = parseInt(dom_this.dataset.show);
        const is_child_selected = dom_parent.querySelector("a[data-selected='1']") != null;

        if (is_child_selected && (isNaN(is_show) || is_show)) {
            this.dataset.show = 0;
        } else if (is_show) {
            this.dataset.show = 0;
        } else {
            this.dataset.show = 1;
        };
    },
};

function getCookie(key) {
    if (!{ string: 1, number: 1 }[typeof key] || String(key).trim().length < 1) {
        return;
    };

    const key_regexp = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)');
    const match_results = document.cookie.match(key_regexp) || [];
    const length = match_results.length;

    if (length < 1) {
        return;
    };

    let target_value = match_results[1];

    target_value = decodeURIComponent(target_value);

    try {
        target_value = JSON.parse(target_value);
    } catch (err) {
        return
    };

    return target_value;
};

function addCookie(key, body, expire) {

    if (!{ string: 1, number: 1 }[typeof key] || String(key).trim().length < 1 || body == null) {
        return;
    };

    key = encodeURIComponent(key);
    expire = (typeof expire === "number" ? expire : 3600) * 1000;

    const now_date = Date.now();
    const date = new Date(now_date + expire);

    body = typeof body === "object" ? JSON.stringify(body).trim() : String(body).trim();
    body = encodeURIComponent(body);

    document.cookie = `${key}=${body}; expires=${date.toUTCString()}; path=/;`;

    return document.cookie;
};
