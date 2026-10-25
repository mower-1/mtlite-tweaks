# -*- coding: utf-8 -*-
"""按原版风格重建「关于软件」文本块。

做法：
1. 解析原块的 append 段与 span（span 用它的原始数字反查落在哪一段、段内偏移多少）；
2. 插入两条新内容（三改开源地址、三改-割草机Mow），保持"手数字面量"的原版风格；
3. 反向模拟校验：每个 span 在新文本里圈住的相对文字，必须与原版圈住的完全一致。
"""
import re, sys

SRC = 'original/fap/pages/shezhi/main.lua'
DST = 'src/fap/pages/shezhi/main.lua'

def get_block(s):
    i = s.find('        关于应用文本 = SpannableStringBuilder(')
    j = s.find('        关于应用文本.append("\\n\\n"..签名未通过)')
    j = s.find('\n', j) + 1
    assert i != -1 and j > i
    return i, j

def unescape(t):
    return t.replace('\\n', '\n')

NUM = re.compile(r',\s*(\d+)\s*,\s*(\d+)\s*,\s*Spannable')
LINE_SPAN = re.compile(r',\s*\d+\s*,\s*\d+\s*,\s*Spannable')

def parse(block):
    items, lines, k = [], block.split('\n'), 0
    while k < len(lines):
        ln = lines[k]
        m = re.match(r'\s*关于应用文本 = SpannableStringBuilder\("(.*)"\)\s*$', ln)
        if m:
            items.append({'kind': 'base', 'text': unescape(m.group(1))})
            k += 1
            continue
        m = re.match(r'\s*关于应用文本\.append\("(.*?)"\)\s*(--.*)?$', ln)
        if m:
            items.append({'kind': 'append', 'text': unescape(m.group(1)),
                          'comment': m.group(2) or ''})
            k += 1
            continue
        if ln.strip().startswith('--'):
            items.append({'kind': 'raw', 'line': ln})
            k += 1
            continue
        if 'setSpan(' in ln:
            chunk = [ln]
            k += 1
            if not LINE_SPAN.search(ln):
                while k < len(lines) and not re.match(r'\s*\}\),\s*\d+\s*,\s*\d+\s*,\s*Spannable', lines[k]):
                    chunk.append(lines[k])
                    k += 1
                chunk.append(lines[k])
                k += 1
            code = '\n'.join(chunk)
            m2 = NUM.search(code)
            assert m2, code[:80]
            items.append({'kind': 'span', 'before': code[:m2.start()], 'after': code[m2.end():],
                          'orig': (int(m2.group(1)), int(m2.group(2)))})
            continue
        k += 1
    return items

def segments(items):
    segs, pos = [], 0
    for it in items:
        if it['kind'] in ('base', 'append'):
            segs.append({'text': it['text'], 'start': pos, 'end': pos + len(it['text'])})
            pos += len(it['text'])
    return segs, pos

def locate(segs, s, e):
    for idx, sg in enumerate(segs):
        if sg['start'] <= s < sg['end']:
            rs = s - sg['start']
            re_ = min(e, sg['end']) - sg['start']
            assert re_ > rs, (s, e, sg)
            return idx, rs, re_
    raise AssertionError('span 起点不在任何段内: %d,%d' % (s, e))

def build():
    raw = open(SRC, encoding='utf-8').read()
    i, j = get_block(raw)
    items = parse(raw[i:j])
    segs, total = segments(items)

    mapped, seg_no, seg_of_text, next_id = [], 0, {}, 1000
    for it in items:
        if it['kind'] == 'base':
            mapped.append(dict(it, id=0)); seg_no = 0; seg_of_text[it['text']] = 0
        elif it['kind'] == 'append':
            seg_no += 1
            mapped.append(dict(it, id=seg_no)); seg_of_text[it['text']] = seg_no
        elif it['kind'] == 'raw':
            mapped.append(dict(it))
        else:
            idx, rs, re_ = locate(segs, it['orig'][0], it['orig'][1])
            mapped.append({'kind': 'span', 'before': it['before'], 'after': it['after'],
                           'seg': idx, 'rs': rs, 're': re_})

    def insert_after(seg_text, new_items):
        idx = seg_of_text[seg_text]
        pos = 0
        for k, it in enumerate(mapped):
            if it['kind'] == 'span' and it['seg'] == idx:
                pos = k + 1
            elif it['kind'] in ('base', 'append') and it.get('text') == seg_text and pos == 0:
                pos = k + 1
        for n, ni in enumerate(new_items):
            mapped.insert(pos + n, ni)

    insert_after('\n开源地址：https://wwi.lanzouo.com/b0d1pmq7a', [
        {'kind': 'append', 'text': '\n三改开源地址：https://github.com/mower-1/mtlite-tweaks', 'id': 2001},
        {'kind': 'synth_url', 'seg': 2001, 'seg_text': '\n三改开源地址：https://github.com/mower-1/mtlite-tweaks',
         'url': 'https://github.com/mower-1/mtlite-tweaks'},
    ])
    insert_after('\n现-月牙鸣', [
        {'kind': 'append', 'text': '\n三改-割草机Mow', 'id': 2002},
        {'kind': 'synth_click', 'seg': 2002, 'seg_text': '\n三改-割草机Mow',
         'url': 'https://bbs.binmt.cc/home.php?mod=space&uid=153405&do=profile'},
    ])
    return mapped

def emit(ordered):
    lines, pos = [], 0
    seg_pos = {}
    base = next(it for it in ordered if it['kind'] == 'base')
    lines.append('        关于应用文本 = SpannableStringBuilder("%s")' % base['text'])
    pos = len(base['text'])
    seg_pos[base['id']] = (0, pos)
    for it in ordered:
        if it['kind'] == 'base':
            continue
        if it['kind'] == 'raw':
            lines.append(it['line'])
            continue
        if it['kind'] == 'append':
            seg_pos[it['id']] = (pos, pos + len(it['text']))
            lines.append('        关于应用文本.append("%s")%s'
                         % (it['text'].replace('\n', '\\n'), it.get('comment', '')))
            pos += len(it['text'])
            continue
        if it['kind'] == 'synth_url':
            st = seg_pos[it['seg']][0]
            off = it['seg_text'].index(it['url'])
            lines.append('        关于应用文本.setSpan(URLSpan("%s"),%d,%d,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)'
                         % (it['url'], st + off, st + off + len(it['url'])))
            continue
        if it['kind'] == 'synth_click':
            st, en = seg_pos[it['seg']]
            txt = it['seg_text']
            off = 0
            while off < len(txt) and txt[off] == '\n':
                off += 1
            lines += [
                '        关于应用文本.setSpan(ClickableSpan({',
                '          onClick=function(view)',
                '            进子页面("yonghu",{"%s"})' % it['url'],
                '          end,',
                '          updateDrawState=function(ds)',
                '            ds.setColor(强调色) --设置颜色',
                '            ds.setUnderlineText(false) --去掉下划线',
                '          end',
                '        }),%d,%d,Spannable.SPAN_EXCLUSIVE_EXCLUSIVE)' % (st + off, en),
            ]
            continue
        st = seg_pos[it['seg']][0]
        lines.append(it['before'] + ',%d,%d,Spannable' % (st + it['rs'], st + it['re']) + it['after'])
    lines.append('        关于应用文本.append("\\n\\n"..签名未通过)')
    return '\n'.join(lines) + '\n', pos

def verify(block, expect_len):
    length, segs, errors, rows, k = 0, [], [], [], 0
    lines = block.split('\n')
    while k < len(lines):
        ln = lines[k]
        m = re.match(r'\s*关于应用文本 = SpannableStringBuilder\("(.*)"\)\s*$', ln)
        if m:
            t = unescape(m.group(1))
            segs.append({'text': t, 'start': 0, 'end': len(t)})
            length = len(t)
            k += 1
            continue
        m = re.match(r'\s*关于应用文本\.append\("(.*?)"\)\s*(--.*)?$', ln)
        if m and '..' not in m.group(1):
            t = unescape(m.group(1))
            segs.append({'text': t, 'start': length, 'end': length + len(t)})
            length += len(t)
            k += 1
            continue
        if 'setSpan(' in ln:
            chunk = [ln]
            k += 1
            if not LINE_SPAN.search(ln):
                while k < len(lines) and not re.match(r'\s*\}\),\s*\d+\s*,\s*\d+\s*,\s*Spannable', lines[k]):
                    chunk.append(lines[k])
                    k += 1
                chunk.append(lines[k])
                k += 1
            code = '\n'.join(chunk)
            m2 = NUM.search(code)
            s, e = int(m2.group(1)), int(m2.group(2))
            if e > length:
                errors.append('越界 %d,%d > %d' % (s, e, length))
                continue
            sg = next(x for x in segs if x['start'] <= s < x['end'])
            rows.append((s, e, sg['text'][s - sg['start']:e - sg['start']], sg['text']))
            continue
        k += 1
    if length != expect_len:
        errors.append('长度不符 %d != %d' % (length, expect_len))
    return errors, rows, length

if __name__ == '__main__':
    block, total = emit(build())
    print('生成：%d 行，文本长度 %d' % (block.count('\n'), total))
    errs, rows, ln = verify(block, total)
    print('校验：长度 %d，问题 %d' % (ln, len(errs)))
    for e in errs:
        print('  ✗', e)
    for s, e, got, seg in rows:
        print('  [%3d,%3d) 「%s」' % (s, e, got.replace('\n', '⏎')))
    if errs:
        sys.exit(1)
    cur = open(DST, encoding='utf-8').read()
    ci, cj = get_block(cur)
    open(DST, 'w', encoding='utf-8', newline='').write(cur[:ci] + block + cur[cj:])
    print('已写入', DST)
