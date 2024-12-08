# -*- mode: python ; coding: utf-8 -*-

block_cipher = None

a = Analysis(
    ['/home/ian/backend/python_demo/main.py'],
    pathex=['/home/ian/backend'],
    binaries=[],
    datas=[('/home/ian/backend/python_demo/main.py', '.')],  # 將 main.py 文件加入 datas 中
    hiddenimports=[
         'fastapi',
        'h11',
        'pydantic',
        'sniffio',
        'starlette',
        'sqlalchemy',
        'uvicorn',
        'greenlet',
        'pymysql',
        'mysql.connector',
        'mysql.connector.plugins.mysql_native_password',  # 加入這個模塊
        'typing_extensions',
    ],
    hookspath=['.'],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        'pip._internal.utils.typing',
        'pydantic.typing',
        'pydantic.v1.typing',
        
    ],
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)
pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='main',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
coll = COLLECT(
    exe,
    a.binaries,
    a.zipfiles,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='python_demo',
)
