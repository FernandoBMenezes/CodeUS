object DMBancoDB: TDMBancoDB
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 480
  Width = 640
  object FDQuery: TFDQuery
    Connection = FDConnection
    Left = 64
    Top = 64
  end
  object FDConnection: TFDConnection
    Left = 152
    Top = 64
  end
  object FDPhysSQLiteDriverLink: TFDPhysSQLiteDriverLink
    VendorLib = 'sqlite3.dll'
    Left = 272
    Top = 64
  end
  object FDSQLiteSecurity: TFDSQLiteSecurity
    DriverLink = FDPhysSQLiteDriverLink
    Left = 424
    Top = 64
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 72
    Top = 392
  end
end
