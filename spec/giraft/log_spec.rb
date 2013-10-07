require 'spec_helper'

describe Giraft::Log do
  it 'initializes with an empty log' do
    log = Giraft::Log.new
    expect(log.entries).to eq([])
  end

  it 'can find entries at an index with a term' do
    log = Giraft::Log.new([
      Giraft::LogEntry.new(100),
      Giraft::LogEntry.new(101),
      Giraft::LogEntry.new(102),
    ])

    expect(log.find(1, 101)).to eq(Giraft::LogEntry.new(101))
  end

  it 'overwrites entries by deleting conflicts and appending new entries' do
    log = Giraft::Log.new
    new_entries = []

    expect(log).to receive(:delete_conflicts).with(new_entries)
    expect(log).to receive(:append).with(new_entries)

    log.overwrite(new_entries)
  end

  it 'deletes conflicting entries' do
    log = Giraft::Log.new([
      Giraft::LogEntry.new(100),
      Giraft::LogEntry.new(101),
      Giraft::LogEntry.new(102),
    ])

    new_entries = [
      Giraft::LogEntry.new(101),
      Giraft::LogEntry.new(102),
      Giraft::LogEntry.new(103),
    ]

    unconflicting = Giraft::Log.new([
      Giraft::LogEntry.new(100)
    ])

    log.delete_conflicts(new_entries)

    expect(log).to eq(unconflicting)
  end

  it 'appends new entries' do
    log = Giraft::Log.new([
      Giraft::LogEntry.new(100),
    ])

    new_entries = [
      Giraft::LogEntry.new(101),
      Giraft::LogEntry.new(102),
    ]

    appended = Giraft::Log.new([
      Giraft::LogEntry.new(100),
      Giraft::LogEntry.new(101),
      Giraft::LogEntry.new(102)
    ])

    log.append(new_entries)

    expect(log).to eq(appended)
  end

  it 'commits verified entries' do
    first_entry = Giraft::LogEntry.new(100),
    second_entry = Giraft::LogEntry.new(101),
    third_entry = Giraft::LogEntry.new(102)

    log = Giraft::Log.new([first_entry, second_entry, third_entry])

    expect(first_entry).to_not receive(:commit)
    expect(second_entry).to receive(:commit)
    expect(third_entry).to_not receive(:commit)

    log.commit(1...2)
  end
end
